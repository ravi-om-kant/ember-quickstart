import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { service } from '@ember/service';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';

/**
 * ProductForm - Create or edit a product
 * Shows:
 * - Creating new product with store.createRecord() + save()
 * - Updating with rollbackAttributes() on error
 * - Error handling and loading states
 */
export default class ProductFormComponent extends Component {
  @service productRepository;
  @service router;

  @tracked title = this.args.product?.title ?? '';
  @tracked price = this.args.product?.price ?? '';
  @tracked description = this.args.product?.description ?? '';

  @tracked error = '';
  @tracked isSaving = false;

  get isEdit() {
    return Boolean(this.args.product);
  }

  get submitLabel() {
    if (this.isSaving) {
      return 'Saving...';
    }
    return this.isEdit ? 'Save Changes' : 'Create Product';
  }

  /**
   * Create new product
   * Uses: store.createRecord() + product.save()
   */
  @action
  async createProduct(event) {
    event.preventDefault();
    this.error = '';
    this.isSaving = true;

    try {
      const product = await this.productRepository.create({
        title: this.title.trim(),
        price: Number(this.price),
        description: this.description.trim(),
      });

      // Success - redirect to detail
      await this.router.transitionTo('product', product.id);
    } catch (err) {
      this.error = err.message || 'Failed to create product';
      this.isSaving = false;
    }
  }

  /**
   * Update existing product
   * Uses: product.save() with automatic rollback on error
   *
   * If save fails, the repository automatically calls
   * product.rollbackAttributes() to undo changes
   */
  @action
  async updateProduct(event) {
    event.preventDefault();
    this.error = '';
    this.isSaving = true;

    try {
      await this.productRepository.update(this.args.product, {
        title: this.title.trim(),
        price: Number(this.price),
        description: this.description.trim(),
      });

      this.args.onSuccess?.('Product updated successfully!');
      this.isSaving = false;
    } catch (err) {
      // Product is automatically rolled back by the repository
      this.error = err.message || 'Failed to update product';
      this.isSaving = false;
    }
  }

  /**
   * Delete product
   * Uses: product.destroyRecord()
   */
  @action
  async deleteProduct() {
    if (!confirm('Are you sure?')) return;

    this.error = '';
    this.isSaving = true;

    try {
      await this.productRepository.delete(this.args.product);
      await this.router.transitionTo('products');
    } catch (err) {
      this.error = err.message || 'Failed to delete product';
      this.isSaving = false;
    }
  }

  <template>
    <form class="form" {{on "submit" (fn (if this.isEdit this.updateProduct this.createProduct))}}>
      {{#if this.error}}
        <div class="error-message">
          ⚠️ {{this.error}}
        </div>
      {{/if}}

      <div class="form-group">
        <label>Title</label>
        <input
          type="text"
          value={{this.title}}
          {{on "change" (fn (mut this.title))}}
          disabled={{this.isSaving}}
        />
      </div>

      <div class="form-group">
        <label>Price</label>
        <input
          type="number"
          value={{this.price}}
          {{on "change" (fn (mut this.price))}}
          disabled={{this.isSaving}}
        />
      </div>

      <div class="form-group">
        <label>Description</label>
        <textarea
          value={{this.description}}
          {{on "change" (fn (mut this.description))}}
          disabled={{this.isSaving}}
        ></textarea>
      </div>

      <div class="form-actions">
        <button type="submit" disabled={{this.isSaving}}>
          {{this.submitLabel}}
        </button>

        {{#if this.isEdit}}
          <button
            type="button"
            class="btn-delete"
            {{on "click" this.deleteProduct}}
            disabled={{this.isSaving}}
          >
            Delete
          </button>
        {{/if}}
      </div>
    </form>

    <style>
      .form {
        max-width: 500px;
        margin: 2rem 0;
      }

      .form-group {
        margin: 1rem 0;
        display: flex;
        flex-direction: column;
      }

      .form-group label {
        margin-bottom: 0.5rem;
        font-weight: bold;
        color: #333;
      }

      .form-group input,
      .form-group textarea {
        padding: 0.5rem;
        border: 1px solid #ddd;
        border-radius: 4px;
        font-size: 1rem;
      }

      .form-group textarea {
        min-height: 100px;
        resize: vertical;
      }

      .form-actions {
        display: flex;
        gap: 1rem;
        margin-top: 2rem;
      }

      button {
        padding: 0.75rem 1.5rem;
        background: #0066cc;
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-weight: 500;
      }

      button:hover:not(:disabled) {
        background: #0052a3;
      }

      button:disabled {
        opacity: 0.6;
        cursor: not-allowed;
      }

      .btn-delete {
        background: #dc3545;
      }

      .btn-delete:hover:not(:disabled) {
        background: #c82333;
      }

      .error-message {
        padding: 1rem;
        background: #fee;
        border: 1px solid #c33;
        color: #c33;
        border-radius: 4px;
        margin-bottom: 1rem;
      }
    </style>
  </template>
}
