import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';

export default class extends Component {
  @tracked isProduct = null;
  @tracked buttonText = "";
  
  handleInfo = (product) => {
    console.log(product);
    if(product.id === this.isProduct){
      this.isProduct = null;
      return;
    }
    this.isProduct = product.id;
  };
  getInfo = (product) => {
    console.log(this.isProduct === product.id)
    const showInfo = this.isProduct === product.id;
    this.buttonText = showInfo ? "Hide Details" : "View Detils";
    return showInfo;
  };

  <template>
    {{!-- <div class="product-card">
      {{! Product Image }}
      <div class="product-image">
        <img src={{@product.thumbnail}} alt={{@product.title}} />
      </div>

      {{! Product Info }}
      <div class="product-info">
        <h3 class="product-title">{{@product.title}}</h3>

        <p class="product-category">{{@product.category}}</p>

        <p class="product-description">{{@product.description}}</p>

        {{! Price & Discount }}
        <div class="product-price">
          <span class="price">${{@product.price}}</span>
          <span class="discount">{{@product.discountPercentage}}% off</span>
        </div>

        {{! Rating }}
        <div class="product-rating">
          <span class="rating">⭐ {{@product.rating}}</span>
        </div>

        {{! Stock & Availability }}
        <div class="product-stock">
          <p class="availability">{{@product.availabilityStatus}}</p>
          <p class="stock-count">Stock: {{@product.stock}}</p>
        </div>

        {{! Brand }}
        <p class="product-brand">
          <strong>Brand:</strong>
          {{@product.brand}}
        </p>

        {{! Reviews }}
        <div class="product-reviews">
          <h4>Reviews ({{@product.reviews.length}})</h4>
          <ul>
            {{#each @product.reviews as |review|}}
              <li class="review-item">
                <p class="review-rating">{{review.rating}} ⭐</p>
                <p class="review-comment">{{review.comment}}</p>
                <p class="review-author">- {{review.reviewerName}}</p>
              </li>
            {{/each}}
          </ul>
        </div>

        {{! Additional Info }}
        <div class="product-details">
          <p><strong>SKU:</strong> {{@product.sku}}</p>
          <p><strong>Weight:</strong> {{@product.weight}}g</p>
          <p><strong>Warranty:</strong> {{@product.warrantyInformation}}</p>
          <p><strong>Shipping:</strong> {{@product.shippingInformation}}</p>
          <p><strong>Return Policy:</strong> {{@product.returnPolicy}}</p>
        </div>

        {{! All Images }}
        <div class="product-images">
          <h4>Product Images</h4>
          <div class="images-grid">
            {{#each @product.images as |image|}}
              <img src={{image}} alt="Product image" class="thumbnail" />
            {{/each}}
          </div>
        </div>

        {{! Action Buttons }}
        <div class="product-actions">
          <button class="btn-add-to-cart">Add to Cart</button>
          <button class="btn-view-details">View Details</button>
        </div>
      </div>
    </div> --}}
   <div class="product-card" {{on "click" (fn this.handleInfo @product)}}>
      <div class="product-image">
        <img src={{@product.thumbnail}} alt={{@product.title}} />
      </div>

      <h3 class="product-title">{{@product.title}}</h3>
      <p class="product-category">{{@product.category}}</p>

      {{! Show details only if this product is selected }}
      {{#if (this.getInfo @product)}}
        <div class="product-details-expanded">
          <p class="product-description">{{@product.description}}</p>

          <div class="product-price">
            <span class="price">${{@product.price}}</span>
            <span class="discount">{{@product.discountPercentage}}% off</span>
          </div>

          <div class="product-rating">
            <span class="rating">⭐ {{@product.rating}}</span>
          </div>

          <div class="product-stock">
            <p class="availability">{{@product.availabilityStatus}}</p>
            <p class="stock-count">Stock: {{@product.stock}}</p>
          </div>

          <div class="product-reviews">
            {{#each @product.reviews as |review|}}
              <div class="review-item">
                <p class="review-rating">{{review.rating}} ⭐</p>
                <p class="review-comment">{{review.comment}}</p>
              </div>
            {{/each}}
          </div>
        </div>
      {{else}}
        <button class="btn-view-details" type="button">Click to view details {{this.buttonText}}</button>
      {{/if}}
    </div>

    <style>
      .product-card {
        border: 1px solid #ddd;
        border-radius: 8px;
        padding: 16px;
        margin: 8px;
        max-width: 300px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
      }

      .product-image {
        width: 100%;
        height: 200px;
        overflow: hidden;
        border-radius: 4px;
        margin-bottom: 12px;
      }

      .product-image img {
        width: 100%;
        height: 100%;
        object-fit: cover;
      }

      .product-title {
        font-size: 18px;
        font-weight: bold;
        margin: 8px 0;
      }

      .product-category {
        color: #666;
        font-size: 12px;
        text-transform: uppercase;
      }

      .product-price {
        display: flex;
        gap: 8px;
        margin: 12px 0;
      }

      .price {
        font-size: 20px;
        font-weight: bold;
        color: #2ecc71;
      }

      .discount {
        background-color: #e74c3c;
        color: white;
        padding: 4px 8px;
        border-radius: 4px;
        font-size: 12px;
      }

      .product-rating {
        margin: 8px 0;
        font-size: 14px;
      }

      .product-stock {
        background-color: #f0f0f0;
        padding: 8px;
        border-radius: 4px;
        margin: 8px 0;
      }

      .availability {
        color: #27ae60;
        font-weight: bold;
        margin: 0;
      }

      .stock-count {
        margin: 4px 0 0 0;
        color: #555;
      }

      .product-reviews {
        margin-top: 16px;
        padding-top: 16px;
        border-top: 1px solid #eee;
      }

      .review-item {
        background-color: #f9f9f9;
        padding: 8px;
        margin: 8px 0;
        border-left: 3px solid #3498db;
      }

      .review-rating {
        font-weight: bold;
        margin: 0 0 4px 0;
      }

      .review-comment {
        margin: 4px 0;
        font-style: italic;
      }

      .review-author {
        margin: 4px 0 0 0;
        color: #666;
        font-size: 12px;
      }

      .product-details {
        background-color: #f5f5f5;
        padding: 12px;
        margin: 12px 0;
        border-radius: 4px;
        font-size: 12px;
      }

      .product-details p {
        margin: 4px 0;
      }

      .images-grid {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 8px;
        margin: 12px 0;
      }

      .thumbnail {
        width: 100%;
        height: 100px;
        object-fit: cover;
        border-radius: 4px;
        cursor: pointer;
      }

      .product-actions {
        display: flex;
        gap: 8px;
        margin-top: 16px;
      }

      .btn-add-to-cart,
      .btn-view-details {
        flex: 1;
        padding: 10px;
        border: none;
        border-radius: 4px;
        font-size: 14px;
        cursor: pointer;
        font-weight: bold;
        transition: all 0.3s ease;
      }

      .btn-add-to-cart {
        background-color: #3498db;
        color: white;
      }

      .btn-add-to-cart:hover {
        background-color: #2980b9;
      }

      .btn-view-details {
        background-color: #95a5a6;
        color: white;
      }

      .btn-view-details:hover {
        background-color: #7f8c8d;
      }
    </style>
  </template>
}
