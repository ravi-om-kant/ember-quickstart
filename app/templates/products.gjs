import { pageTitle } from 'ember-page-title';
import Products from '../components/products.gjs';
import AppHeaderComponent from '../components/appheader.gjs';
import { on } from '@ember/modifier';
import { fn, array, eq } from '@ember/helper';

<template>
  {{pageTitle "Products"}}
  <AppHeaderComponent />

  <div class="products-page">
        <div class="controls">
          <div class="search-box">
            <label>Search Products:</label>
            <input
              type="text"
              value={{@controller.q}}
              {{on "change" @controller.updateQuery}}
              placeholder="eg. phone, laptop, keyboard..."
            />
            {{#if @controller.q}}
              <button type="button" {{on "click" (fn (mut @controller.q) "")}}>Clear</button>
            {{/if}}
          </div>
          <div class="pagination-controls">
            <label>Items per Page:</label>
            <select
              value={{@controller.limit}}
              {{on "change" @controller.updateLimit}}
            >
              {{#each (array 5 10 20 30) as |p|}}
                <option
                  value={{p}}
                  selected={{eq p @controller.limit}}
                >{{p}}</option>
              {{/each}}
            </select>
            <button
              disabled={{@controller.isFirstPage}} type="button" {{on "click" @controller.previousPage}}
            >← Previous</button>
            <span class="page-info">
              Showing
              {{@controller.rangeStart}}–{{@controller.rangeEnd}}
            </span>

            <button
              type="button"
              {{on "click" @controller.nextPage}}
              disabled={{@controller.isLastPage}}
            >
              Next →
            </button>
          </div>
        </div>

    <Products @products={{@model.products}} />
  </div>

  <style>
    .loading-container {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      min-height: 300px;
      background: #f9f9f9;
      padding: 2rem;
      margin: 20px;
      border-radius: 8px;
    }

    .spinner {
      width: 50px;
      height: 50px;
      border: 4px solid #e0e0e0;
      border-top: 4px solid #0066cc;
      border-radius: 50%;
      animation: spin 0.8s linear infinite;
    }

    .loading-text {
      margin-top: 1rem;
      font-size: 18px;
      color: #666;
      font-weight: 500;
    }

    @keyframes spin {
      0% {
        transform: rotate(0deg);
      }
      100% {
        transform: rotate(360deg);
      }
    }

    .products-page {
      padding: 20px;
    }

    .controls {
      background: #f5f5f5;
      padding: 20px;
      border-radius: 8px;
      margin-bottom: 20px;
      display: flex;
      gap: 20px;
      flex-wrap: wrap;
      align-items: center;
    }

    .search-box {
      display: flex;
      gap: 10px;
      align-items: center;
    }

    .search-box input {
      padding: 8px 12px;
      border: 1px solid #ddd;
      border-radius: 4px;
      width: 300px;
    }

    .pagination-controls {
      display: flex;
      gap: 10px;
      align-items: center;
    }

    .pagination-controls button {
      padding: 8px 12px;
      background: #007bff;
      color: white;
      border: none;
      border-radius: 4px;
      cursor: pointer;
    }

    .pagination-controls button:disabled {
      background: #ccc;
      cursor: not-allowed;
    }

    .page-info {
      font-weight: bold;
      color: #666;
    }
  </style>
</template>
