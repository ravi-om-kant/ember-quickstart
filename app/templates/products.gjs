import { pageTitle } from 'ember-page-title';
import Products from '../components/products.gjs';
import AppHeaderComponent from '../components/appheader.gjs';
import { on } from '@ember/modifier';
import { fn, array, eq } from '@ember/helper';
<template>
  {{pageTitle "Products"}}
  <AppHeaderComponent />

  {{outlet}}
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
          <button {{on "click" (fn (mut @controller.q) "")}}>Clear</button>
        {{/if}}
      </div>
      {{!-- {{#if (not @controller.hasSearchTerm)}} --}}
        <div class="pagination-controls">
          <label>Items per Page:</label>
          <select
            value={{@controller.limit}}
            {{on "change" (fn @controller.updateLimit)}}
          >
            {{#each (array 5 10 20 30) as |p|}}
              <option
                value={{p}}
                selected={{eq p @controller.limit}}
              >{{p}}</option>
            {{/each}}
          </select>
          <button
            {{on "click" (fn @controller.previousPage)}}
            disabled={{@controller.isFirstPage}}
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
      {{!-- {{/if}} --}}
    </div>
    {{#if @model.error}}
      <div class="error-box">
        <h3>⚠️ {{@model.message}}</h3>
        <p>{{@model.type}}</p>
      </div>
    {{else}}
      <Products @data={{@model}} />
    {{/if}}
  </div>
  <style>
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

    .error-box {
      background: #fee;
      border: 2px solid #c33;
      border-radius: 8px;
      padding: 20px;
      color: #c33;
    }
  </style>
</template>
// import { helper } from '@ember/component/helper';
// import config from '../config/environment';

// const getConfig = helper(() => config);

// <template>
//   {{getConfig.APP.API_HOST}}  // ✅ Parentheses to call it
// </template>
