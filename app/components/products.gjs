import ProductCard from './product-card.gjs';

<template>
  {{! DEBUG: Check what @products contains }}
  {{#if @data.products}}
    <p>✅ Products received: {{@data.products.length}} items out of {{@data.total}}</p>
  {{else}}
    <p>❌ @products is empty or undefined</p>
  {{/if}}

  <div class="products">
    {{#each @data.products as |product|}}

      <ProductCard @product={{product}} />
    {{else}}
      <div class="no-products">
        <h3>No Products Found</h3>
        <p>Try adjusting your search or browsing all products.</p>
      </div>
    {{/each}}
  </div>

  <style>
    .products {
      display: flex;
      flex-wrap: wrap;
      gap: 16px;
      padding: 16px;
    }
    .no-products {
      text-align: center;
      padding: 40px;
      color: #666;
      width: 100%;
    }
  </style>
</template>
