# WarpDrive Models - Complete Implementation

## 🎯 What We've Built

A complete data layer using WarpDrive models with:
- ✅ **Models** - ProductModel, CategoryModel, ReviewModel
- ✅ **Store Transformations** - DummyJSON → JSON:API
- ✅ **Repository Service** - Encapsulates all data operations
- ✅ **Routes** - Using repository for data loading
- ✅ **Components** - Create/Update/Delete with rollback

---

## 📁 File Structure

```
app/
├── models/
│   ├── product.js          ← Defines fields and relationships
│   ├── category.js         ← Category model
│   └── review.js           ← Review model
│
├── services/
│   ├── store.js            ← WarpDrive config + handler
│   └── product-repository.js ← All data operations
│
├── routes/
│   ├── products.js         ← Lists using repository.query()
│   └── product.js          ← Detail using repository.findRecord()
│
└── components/
    └── product-form.gjs    ← Create/Update/Delete with rollback
```

---

## 🔄 Data Flow

### **1. Query Products (List View)**

```
User visits /products
  ↓
ProductsRoute.model()
  ↓
productRepository.query({ q, limit, skip })
  ↓
Handler intercepts request
  ↓
Transforms DummyJSON → JSON:API
  ↓
Store creates ProductModel instances
  ↓
Route returns array of models
  ↓
Template displays with {{@model.products}}
```

### **2. Load Product (Detail View)**

```
User clicks product
  ↓
ProductRoute.model({ id })
  ↓
productRepository.findWithRelationships(id)
  ↓
Loads product via store.findRecord()
  ↓
Loads reviews via await product.reviews
  ↓
Route returns { product, reviews }
  ↓
Template shows product + reviews
```

### **3. Create Product**

```
User fills form + clicks Create
  ↓
productForm.createProduct()
  ↓
productRepository.create({ title, price, ... })
  ↓
store.createRecord('product', attrs)
  ↓
await product.save()
  ↓
Handler transforms request to JSON:API
  ↓
API receives and processes
  ↓
Success → Redirect to detail
  ↓
Failure → Catch error, show message
```

### **4. Update Product**

```
User edits form + clicks Save
  ↓
productForm.updateProduct()
  ↓
productRepository.update(product, { title, price, ... })
  ↓
Apply changes to model
  ↓
await product.save()
  ↓
Success → Show success message
  ↓
Failure → Automatically rollback changes
```

### **5. Delete Product**

```
User clicks Delete
  ↓
productForm.deleteProduct()
  ↓
Confirm dialog
  ↓
productRepository.delete(product)
  ↓
await product.destroyRecord()
  ↓
Success → Redirect to list
  ↓
Failure → Show error message
```

---

## 📚 Repository Methods

### **query(params)** - Load list with filters
```js
const { products, total } = await this.productRepository.query({
  q: 'phone',
  limit: 10,
  skip: 0
});
// Returns: { products: Array<ProductModel>, total, skip, limit }
// Always hits API (no cache)
```

### **findRecord(id, options)** - Load one with caching
```js
const product = await this.productRepository.findRecord(1);
// Returns: ProductModel instance
// Cached by ID - second call returns from cache
// Pass { reload: true } to force fresh load
```

### **findWithRelationships(id)** - Load with async relationships resolved
```js
const { product, reviews } = await this.productRepository.findWithRelationships(1);
// Returns: { product: ProductModel, reviews: Array<ReviewModel> }
// Reviews resolved in route, templates don't need to await
```

### **create(attributes)** - Create new record
```js
const product = await this.productRepository.create({
  title: 'New Product',
  price: 100,
  description: '...'
});
// Returns: ProductModel instance (now persisted)
```

### **update(product, attributes)** - Update with rollback
```js
try {
  await this.productRepository.update(product, {
    title: 'Updated',
    price: 150
  });
} catch (error) {
  // product is automatically rolled back
  // All changes are undone
}
```

### **delete(product)** - Delete record
```js
await this.productRepository.delete(product);
// Sends DELETE request
// Removes from cache on success
```

---

## 🔗 How Models Work

### **Model Definition** (product.js)
```js
import Model, { attr, hasMany } from '@warp-drive/legacy/model';

export default class ProductModel extends Model {
  @attr('string') title;
  @attr('number') price;
  
  @hasMany('review', { async: true }) reviews;
}
```

**What this means:**
- `@attr('string')` = field from API (title)
- `@attr('number')` = field from API (price)
- `@hasMany('review')` = one-to-many relationship
- `async: true` = load on-demand

### **Model Instance** (created by store)
```js
const product = ProductModel.create({
  id: 1,
  title: 'iPhone',
  price: 999
});

// Now you can:
product.title        // 'iPhone'
product.price        // 999
product.reviews      // Promise that loads reviews
await product.reviews // Array<ReviewModel>

// And modify:
product.title = 'iPhone 15';
await product.save();  // Persist changes

// Or revert:
product.rollbackAttributes();  // Undo changes
```

---

## 💾 Key Features

### **Live Shared Records**
```js
// Route A loads product
const product1 = await store.findRecord('product', 1);

// Route B loads same product
const product2 = await store.findRecord('product', 1);

// Same object!
product1 === product2  // true

// Change in Route A is visible in Route B
product1.title = 'New';
product2.title  // 'New' (instantly!)
```

### **Automatic Rollback on Error**
```js
// In component:
try {
  product.title = 'New Title';
  await product.save();
} catch (error) {
  // Repository automatically rolled back
  product.title  // Back to original
}
```

### **Caching**
```js
// First call: hits API
const p1 = await store.findRecord('product', 1);

// Second call: returns from cache (instant!)
const p2 = await store.findRecord('product', 1);

// Force fresh load
const p3 = await store.findRecord('product', 1, { reload: true });
```

---

## 🚀 Usage in Templates

### **Display Models**
```hbs
{{! Templates can access model properties }}
<h1>{{@model.product.title}}</h1>
<p>${{@model.product.price}}</p>
```

### **Iterate Collections**
```hbs
{{#each @model.products as |product|}}
  <div>
    {{product.title}} - ${{product.price}}
  </div>
{{/each}}
```

### **Render Components**
```hbs
<ProductForm
  @product={{@model.product}}
  @onSuccess={{this.showMessage}}
/>
```

---

## ✨ What Makes This Powerful

| Feature | Benefit |
|---------|---------|
| **Models** | Type-safe, structured data |
| **Relationships** | Easy traversal (product.reviews) |
| **Caching** | No duplicate network requests |
| **Live updates** | Change once, see everywhere |
| **Rollback** | Undo on error automatically |
| **Repository** | Single source for data logic |

---

## 🎯 Next Steps

This implementation is **production-ready** and shows:
- ✅ How to query lists
- ✅ How to load single records
- ✅ How to create records
- ✅ How to update with rollback
- ✅ How to delete
- ✅ How to handle relationships
- ✅ How to handle errors

You can now extend it with:
- Advanced filtering
- Pagination
- Search
- Sorting
- Validation
- Custom computed properties on models

---

**Models make data management predictable and powerful!**
