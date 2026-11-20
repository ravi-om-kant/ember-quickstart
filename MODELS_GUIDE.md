# WarpDrive Models Guide - ember-quickstart

## 🎯 What Are Models?

Models are **the blueprint for your data**. They define:
- What fields exist (`@attr`)
- Relationships between records (`@belongsTo`, `@hasMany`)
- Computed properties and methods
- How to persist changes (`save()`, `rollbackAttributes()`)

---

## 📋 Models in This Project

### **ProductModel** (`app/models/product.js`)
```js
import Model, { attr, hasMany } from '@warp-drive/legacy/model';

export default class ProductModel extends Model {
  @attr('string') title;
  @attr('number') price;
  @attr('string') description;
  
  @hasMany('review', { async: true }) reviews;
}
```

**What it means:**
- `title`, `price`, `description` are plain fields from the API
- `reviews` is a relationship: a product **has many** reviews
- `async: true` means reviews load on-demand (don't load with product)

---

## 🔄 How Data Flows

### **Step 1: API Response (Plain JSON)**
```js
// DummyJSON returns:
{
  id: 1,
  title: "iPhone",
  price: 999,
  description: "...",
  reviews: [...]  // Not included in list requests
}
```

### **Step 2: Handler Transforms to JSON:API**
```js
// Handler transforms to:
{
  data: {
    type: "product",
    id: "1",
    attributes: {
      title: "iPhone",
      price: 999,
      description: "...",
      reviews: [...]  // Stripped out of attributes
    }
  }
}
```

### **Step 3: Store Creates Model Instance**
```js
// Store cache automatically creates:
const product = ProductModel.create({
  id: 1,
  title: "iPhone",
  price: 999,
  description: "...",
});

// Now you can:
product.title        // "iPhone"
product.price        // 999
product.reviews      // Promise that loads reviews on-demand
```

### **Step 4: Template Uses Model**
```hbs
<h1>{{@model.product.title}}</h1>
<p>${{@model.product.price}}</p>

{{#each @model.reviews as |review|}}
  <p>{{review.comment}}</p>
{{/each}}
```

---

## 📚 Store Operations

### **1. Load One Record**
```js
// In route:
async model({ id }) {
  const product = await this.store.findRecord('product', id);
  
  // product is a ProductModel instance
  // You can access properties:
  product.title        // string
  product.reviews      // Promise (async: true)
  
  return { product };
}
```

### **2. Load Many Records (List)**
```js
// In route:
async model() {
  const products = await this.store.query('product', {
    page: 1,
    limit: 10
  });
  
  // products is an array of ProductModel instances
  products[0].title    // "iPhone"
  products[0].price    // 999
  
  return { products };
}
```

### **3. Create New Record**
```js
// In component action:
@action
async createProduct() {
  const product = this.store.createRecord('product', {
    title: 'New Product',
    price: 100,
    description: 'A new product'
  });
  
  // Record is in memory, not saved yet
  // Modify properties:
  product.title = 'Updated Title';
  
  // Save to API:
  try {
    await product.save();
    // Success - record is saved
  } catch (error) {
    product.rollbackAttributes();
    // Revert to original state
    throw error;
  }
}
```

### **4. Update Record**
```js
// In component action:
@action
async updateProduct(product) {
  // Modify the model
  product.title = 'New Title';
  product.price = 150;
  
  try {
    await product.save();
    // Sent PATCH request with changed attributes
  } catch (error) {
    product.rollbackAttributes();
    throw error;
  }
}
```

### **5. Delete Record**
```js
// In component action:
@action
async deleteProduct(product) {
  try {
    await product.destroyRecord();
    // Sent DELETE request, removed from cache
  } catch (error) {
    // Record still in cache on failure
    throw error;
  }
}
```

---

## 🔗 Relationships

### **Sync Relationships** (`async: false`)
```js
// In route:
const product = await this.store.findRecord('product', 1, {
  include: 'category'  // Load category with product
});

// In template:
<p>Category: {{@model.product.category.name}}</p>
// Works immediately - no waiting
```

### **Async Relationships** (`async: true`)
```js
// In route:
const product = await this.store.findRecord('product', 1);

// Method 1: Resolve in route
const reviews = await product.reviews;
return { product, reviews };

// Method 2: Resolve in template
{{#each (await @model.product.reviews) as |review|}}
  <p>{{review.comment}}</p>
{{/each}}
```

---

## 💾 Live Shared Records

**Key concept:** When you load a record via the store, it becomes a **live shared object**.

```js
// Route A loads product 1
const product = await this.store.findRecord('product', 1);

// In Route B, load same product
const sameProduct = await this.store.findRecord('product', 1);

// They're the SAME object!
product === sameProduct  // true!

// If you modify product:
product.title = 'New Title';

// Route B sees the change immediately
sameProduct.title  // 'New Title'
```

**Why?** The store maintains one cached copy per record. Everyone sees the same instance.

---

## 🎬 Complete Example

### **Route: Show Product Detail**
```js
// app/routes/product.js
export default class ProductRoute extends AuthenticatedRoute {
  @service store;

  async model({ id }) {
    // Load product and resolve relationships
    const product = await this.store.findRecord('product', id, {
      include: 'category'
    });
    const reviews = await product.reviews;
    
    return { product, reviews };
  }
}
```

### **Template: Display Product**
```hbs
{{! app/templates/product.gjs }}
<h1>{{@model.product.title}}</h1>
<p>${{@model.product.price}}</p>

<h2>Category</h2>
<p>{{@model.product.category.name}}</p>

<h2>Reviews ({{@model.reviews.length}})</h2>
{{#each @model.reviews as |review|}}
  <p>⭐ {{review.rating}} - {{review.comment}}</p>
{{/each}}
```

### **Component: Edit Product**
```js
// app/components/product-editor.gjs
@action
async save() {
  this.args.product.title = this.title;
  this.args.product.price = this.price;
  
  try {
    await this.args.product.save();
    this.onSuccess?.('Product updated!');
  } catch (error) {
    this.args.product.rollbackAttributes();
    this.onError?.(error.message);
  }
}
```

---

## 🚀 Summary

| Operation | Use Case | Returns |
|-----------|----------|---------|
| `findRecord(type, id)` | Load one record | Promise<ModelInstance> |
| `query(type, params)` | Load filtered list | Promise<Array<ModelInstance>> |
| `findAll(type)` | Load all records | Promise<Array<ModelInstance>> |
| `createRecord(type, attrs)` | Create in memory | ModelInstance (not saved) |
| `record.save()` | Persist changes | Promise<ModelInstance> |
| `record.rollbackAttributes()` | Undo changes | void |
| `record.destroyRecord()` | Delete from API | Promise |

---

## ✨ Benefits of Models

✅ **Type safety** - Know what fields exist  
✅ **Relationships** - Easy traversal (product.reviews)  
✅ **Live updates** - Change one, everyone sees it  
✅ **Computed properties** - product.priceDisplay  
✅ **Methods** - product.save(), product.destroyRecord()  
✅ **Caching** - Automatic, no duplicate loads  
✅ **Validation** - Can add custom validators  

---

**Models make data management predictable and powerful!**
