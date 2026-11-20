<template>
  <div class="product-loading">
    <div class="spinner"></div>
    <p class="loading-text">Loading product details...</p>
  </div>

  <style>
    .product-loading {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      min-height: 400px;
      padding: 2rem;
      background: #f9f9f9;
    }

    .spinner {
      width: 60px;
      height: 60px;
      border: 4px solid #e0e0e0;
      border-top: 4px solid #0066cc;
      border-radius: 50%;
      animation: spin 0.8s linear infinite;
    }

    .loading-text {
      margin-top: 1.5rem;
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
  </style>
</template>
