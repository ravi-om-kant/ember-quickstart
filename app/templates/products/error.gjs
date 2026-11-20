import { LinkTo } from '@ember/routing';
import { on } from '@ember/modifier';

<template>
  <div class="products-error">
    <div class="error-content">
      <h2>Failed to Load Products</h2>
      <p class="error-message">{{@model.message}}</p>

      <div class="error-actions">
        <button class="retry-button" type="button" {{on "click" this.retry}}>
          🔄 Try Again
        </button>
        <LinkTo @route="login" class="back-button">
          Back to Login
        </LinkTo>
      </div>
    </div>
  </div>

  <style>
  .products-error {
    padding: 20px;
    min-height: 300px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: linear-gradient(135deg, #fee 0%, #fdd 100%);
  }

  .error-content {
    background: white;
    padding: 2rem;
    border-radius: 12px;
    border: 2px solid #c33;
    max-width: 500px;
    text-align: center;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  }

  .error-content h2 {
    color: #c33;
    margin: 0 0 1rem 0;
  }

  .error-message {
    color: #666;
    margin: 1rem 0;
    line-height: 1.6;
  }

  .error-actions {
    display: flex;
    gap: 1rem;
    justify-content: center;
    margin-top: 1.5rem;
  }

  .retry-button,
  .back-button {
    padding: 0.75rem 1.5rem;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-size: 16px;
    font-weight: 500;
    transition: all 0.3s ease;
    text-decoration: none;
    display: inline-block;
  }

  .retry-button {
    background: #0066cc;
    color: white;
  }

  .retry-button:hover {
    background: #0052a3;
    transform: translateY(-2px);
  }

  .back-button {
    background: #6c757d;
    color: white;
  }

  .back-button:hover {
    background: #5a6268;
    transform: translateY(-2px);
  }
  </style>
</template>
