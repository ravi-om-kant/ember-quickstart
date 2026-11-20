# Component Composition - Complete Guide

## 🎯 What Changed?

Your `people-list` component was **hardcoded**. Now it's **flexible**.

---

## ❌ BEFORE: Hardcoded (Bad)

```js
// people-list.gjs - hardcoded display
export default class PeopleList {
  <template>
    <h2>{{@title}}</h2>
    {{#each @people as |person|}}
      <li>
        <button {{on "click" (fn this.showPerson person)}}>
          {{person}}
        </button>
        {{#if (this.isCurrentPerson person)}}
          ⬅️
        {{/if}}
      </li>
    {{/each}}
  </template>
}
```

**Problems:**
- ❌ Button is hardcoded - can't use elsewhere
- ❌ Selection logic is hardcoded
- ❌ Can't change how items look
- ❌ Reusing requires duplicating code

---

## ✅ AFTER: Composable (Good)

```js
// people-list.gjs - flexible wrapper
<template>
  <section class="people-list">
    {{#if (has-block "header")}}
      <div class="people-list__header">
        {{yield to="header"}}
      </div>
    {{else}}
      <h2>{{@title}}</h2>
    {{/if}}

    <ol>
      {{#each @people as |person|}}
        <li>
          {{yield person to="item"}}  {{! ← Parent decides what goes here }}
        </li>
      {{/each}}
    </ol>

    {{#if (has-block "footer")}}
      <div class="people-list__footer">
        {{yield to="footer"}}
      </div>
    {{/if}}
  </section>
</template>
```

**Benefits:**
- ✅ Parent controls content
- ✅ One component, infinite layouts
- ✅ Easy to reuse
- ✅ Flexible styling

---

## 📊 Comparison

| Feature | Before | After |
|---------|--------|-------|
| **Hardcoded display** | ❌ Yes | ✅ No |
| **Parent can customize** | ❌ No | ✅ Yes |
| **Can add buttons** | ❌ No | ✅ Easy |
| **Can add headers** | ❌ No | ✅ Easy |
| **Can add footers** | ❌ No | ✅ Easy |
| **Reusable** | ❌ Limited | ✅ Unlimited |

---

## 🎨 Usage Examples

### Example 1: Simple List (Text Only)

```js
<PeopleList @title="Team" @people={{teamMembers}}>
  <:item as |member|>
    👤 {{member}}
  </:item>
</PeopleList>
```

**Output:**
```
Team
- 👤 Alice
- 👤 Bob
- 👤 Charlie
```

---

### Example 2: With Buttons

```js
<PeopleList @title="Contact" @people={{teamMembers}}>
  <:item as |member|>
    <div class="flex">
      {{member}}
      <button>Message</button>
    </div>
  </:item>
</PeopleList>
```

**Output:**
```
Contact
- Alice    [Message] 
- Bob      [Message]
- Charlie  [Message]
```

---

### Example 3: Custom Header + Footer

```js
<PeopleList @people={{departments}}>
  <:header>
    <strong>📊 Departments ({{departments.length}})</strong>
  </:header>

  <:item as |dept|>
    <div class="card">
      <h4>{{dept.name}}</h4>
      <p>Led by: {{dept.lead}}</p>
    </div>
  </:item>

  <:footer>
    Last updated: Today
  </:footer>
</PeopleList>
```

**Output:**
```
📊 Departments (3)
─────────────────
Engineering
Led by: Alice
─────────────────
Design
Led by: Bob
─────────────────
Product
Led by: Charlie
─────────────────
Last updated: Today
```

---

## 🔑 Key Concepts

### 1. **Named Blocks** (Multiple yield areas)

**PeopleList defines:**
```js
{{yield to="header"}}    {{! Parent can fill this }}
{{yield to="item"}}      {{! Parent fills this for each item }}
{{yield to="footer"}}    {{! Parent can fill this }}
```

**Parent provides:**
```js
<:header>...</:header>   {{! Optional }}
<:item as |data|>...</:item>  {{! Required }}
<:footer>...</:footer>   {{! Optional }}
```

---

### 2. **Yielding Data**

**PeopleList passes data:**
```js
{{yield person to="item"}}
           ↑
     This data is available to parent
```

**Parent receives it:**
```js
<:item as |person|>
       ↑
    Name for the data
  {{person.name}}
```

---

### 3. **Optional Blocks**

**PeopleList checks if block exists:**
```js
{{#if (has-block "header")}}
  {{yield to="header"}}
{{else}}
  {{! Default fallback }}
  <h2>{{@title}}</h2>
{{/if}}
```

**Parent can omit blocks:**
```js
{{! No header block - uses default title }}
<PeopleList @title="Team" @people={{people}}>
  <:item as |person|>...</:item>
</PeopleList>
```

---

## 📁 File Changes

### people-list.gjs
- **Removed:** `showPerson`, `isCurrentPerson` methods
- **Removed:** Hardcoded button, selection logic
- **Added:** Named blocks (header, item, footer)
- **Added:** `{{yield to="item"}}` for flexible content

### component-composition.gjs
- **Added:** 4 usage examples
- **Shows:** How to use the same component differently
- **Demonstrates:** Optional blocks, custom styling, complex objects

---

## 🚀 When to Use Composition

✅ **Use composition when:**
- Component will be used in multiple ways
- Parent needs to control layout
- You want flexible, reusable components
- Different pages need different styling

❌ **Don't use composition when:**
- Component is always the same
- One hardcoded use case
- Very simple, one-off component

---

## 💡 Real-World Examples

### Product Cards (From your app!)

```js
// Before: Hardcoded
<ProductCard>
  <h3>{{product.title}}</h3>
  <p>${{product.price}}</p>
  <button>Details</button>  {{! Always here }}
</ProductCard>

// After: Composable
<ProductCard @product={{product}}>
  <:header>{{product.title}}</:header>
  <:body>${{product.price}}</:body>
  <:footer>
    <button>Details</button> {{! Parent decides }}
    <button>Add to Cart</button>
  </:footer>
</ProductCard>
```

---

## ✨ Summary

| Concept | Explanation |
|---------|-------------|
| **{{yield}}** | Parent fills the content |
| **{{yield to="name"}}** | Multiple yield areas (named blocks) |
| **<:name as \|data\|>** | Parent provides a named block |
| **has-block "name"** | Check if parent provided a block |
| **Composition** | Build flexible, reusable components |

**The key: Components should be as generic as possible, with layout controlled by parents!** 🎯

