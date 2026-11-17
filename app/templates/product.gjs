import { pageTitle } from 'ember-page-title';
import ProductCard from '../components/product-card.gjs';
import { LinkTo } from '@ember/routing';

<template>
  {{pageTitle "Product"}}
  <LinkTo @route="products">← Back to Products</LinkTo>
  {{#if @model.error}}
    <div>
      <h2>Error</h2>
      <p>{{@model.message}}</p>
    </div>
  {{else if @model}}
    <ProductCard @product={{@model}} />
  {{else}}
    <p>Loading...</p>
  {{/if}}
  {{outlet}}
</template>
