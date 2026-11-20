import { trackedMap } from '@ember/reactive/collections';
import Component from '@glimmer/component';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { fn, get } from '@ember/helper';

export default class MapTracked extends Component {
  cart = trackedMap(); // ← Empty map to start

  @action
  addToCart(productId, quantity) {
    this.cart.set(productId, quantity); // ✅ Reactive
  }

  @action
  submitCart(event) {
    event.preventDefault();

    const formData = new FormData(event.target);
    const productId = formData.get('productId');
    const quantity = Number(formData.get('quantity'));

    if (productId && quantity > 0) {
      this.addToCart(productId, quantity);
      event.target.reset();
    }
  }

  @action
  removeFromCart(productId) {
    this.cart.delete(productId); // ✅ Reactive
  }

  get cartSize() {
    return this.cart.size; // ✅ Updates when items change
  }

  <template>
    <p>Cart items: {{this.cartSize}}</p>
    {{#each this.cart as |entry|}}
      <p>
        Product {{get entry "0"}}: {{get entry "1"}} units
        <button type="button" {{on "click" (fn this.removeFromCart (get entry "0"))}}>Remove</button>
      </p>
    {{/each}}
    <form {{on "submit" this.submitCart}}>
      <label>
        ProductId:
        <input name="productId" type="text" required />
      </label>
      <label>
        Quantity:
        <input name="quantity" type="number" min="1" required />
      </label>
      <button type="submit">Add to cart</button>
    </form>
  </template>
}

/*
import { trackedSet } from '@ember/reactive/collections';

export default class FavoritesComponent extends Component {
  favorites = trackedSet();

  @action
  toggleFavorite(id) {
    if (this.favorites.has(id)) {
      this.favorites.delete(id);  // Remove if exists
    } else {
      this.favorites.add(id);     // Add if not exists
    }
  }

  <template>
    <p>Favorites count: {{this.favorites.size}}</p>
    {{#each this.favorites as |id|}}
      <span class="favorite">{{id}} ⭐</span>
    {{/each}}
  </template>
}
// app/components/products.gjs or route
import { Component } from '@glimmer/component';
import { trackedArray } from '@ember/reactive/collections';
import { action } from '@ember/object';

export default class ProductsComponent extends Component {
  filters = trackedArray(['electronics', 'clothing']);
  selectedProducts = trackedSet();

  @action
  addFilter(filter) {
    this.filters.push(filter);  // ✅ Reactive
  }

  @action
  toggleSelected(productId) {
    if (this.selectedProducts.has(productId)) {
      this.selectedProducts.delete(productId);
    } else {
      this.selectedProducts.add(productId);
    }
  }
}

*/
