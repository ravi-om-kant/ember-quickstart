<template>
  <div class="error-container">
    <div class="error-content">
      <h2 class="error-title">⚠️ Something Went Wrong</h2>
      <p class="error-message">{{@model.message}}</p>

      <button class="error-button" type="button" {{on "click" this.retry}}>
        Try Again
      </button>
    </div>
  </div>

  <style>
    .error-container {
      display: flex;
      align-items: center;
      justify-content: center;
      min-height: calc(100vh - 100px);
      background: linear-gradient(135deg, #fee 0%, #fdd 100%);
      padding: 20px;
    }

    .error-content {
      background: white;
      padding: 2rem;
      border-radius: 12px;
      border: 2px solid #c33;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
      max-width: 500px;
      text-align: center;
    }

    .error-title {
      color: #c33;
      margin: 0 0 1rem 0;
      font-size: 24px;
    }

    .error-message {
      color: #666;
      margin: 1rem 0;
      line-height: 1.6;
    }

    .error-button {
      padding: 0.75rem 1.5rem;
      background: #0066cc;
      color: white;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      font-size: 16px;
      font-weight: 500;
      transition: all 0.3s ease;
      margin-top: 1rem;
    }

    .error-button:hover {
      background: #0052a3;
      transform: translateY(-2px);
      box-shadow: 0 4px 8px rgba(0, 102, 204, 0.3);
    }

    .error-button:active {
      transform: translateY(0);
    }
  </style>
</template>
