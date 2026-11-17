import ProductCard from './product-card.gjs';

<template>
  {{! DEBUG: Check what @products contains }}
  {{#if @products}}
    <p>✅ Products received: {{@products.length}} items</p>
  {{else}}
    <p>❌ @products is empty or undefined</p>
  {{/if}}

  <div class="products">
    {{#each @data.products as |product|}}

      <ProductCard @product={{product}} />
    {{else}}
      <h3>No Products found.</h3>
    {{/each}}
  </div>

  <style>
    .products {
      display: flex;
      flex-wrap: wrap;
      gap: 16px;
      padding: 16px;
    }
  </style>
</template>
