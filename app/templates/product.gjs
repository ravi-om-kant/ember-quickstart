import { pageTitle } from 'ember-page-title';
import ProductCard from '../components/product-card.gjs';
import { LinkTo } from '@ember/routing';

<template>
  {{pageTitle "Product"}}
  <div class="product-container">
    <LinkTo @route="products" class="back-link">← Back to Products</LinkTo>
    <ProductCard @product={{@model.product}} />

    {{#if @model.reviews}}
      <div class="reviews-section">
        <h3>Customer Reviews</h3>
        {{#each @model.reviews as |review|}}
          <div class="review">
            <p class="rating">★ {{review.rating}}/5</p>
            <p class="comment">{{review.comment}}</p>
            <p class="reviewer">— {{review.reviewerName}}</p>
          </div>
        {{/each}}
      </div>
    {{/if}}
  </div>

  <style>
    .product-container {
      padding: 20px;
    }

    .back-link {
      display: inline-block;
      margin-bottom: 20px;
      color: #0066cc;
      text-decoration: none;
      font-weight: 500;
    }

    .back-link:hover {
      text-decoration: underline;
    }

    .reviews-section {
      margin-top: 2rem;
      padding-top: 2rem;
      border-top: 1px solid #ddd;
    }

    .review {
      padding: 1rem;
      margin: 1rem 0;
      background: #f9f9f9;
      border-radius: 4px;
      border-left: 4px solid #ffc107;
    }

    .review .rating {
      color: #ffc107;
      font-weight: bold;
      margin: 0 0 0.5rem 0;
    }

    .review .comment {
      margin: 0.5rem 0;
      color: #333;
    }

    .review .reviewer {
      margin: 0.5rem 0 0 0;
      color: #666;
      font-size: 0.9rem;
      font-style: italic;
    }
  </style>
</template>
