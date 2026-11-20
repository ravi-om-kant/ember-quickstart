import ProductCard from './product-card.gjs';

<template>
  <div class="products">
    {{#each @products as |product|}}
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
