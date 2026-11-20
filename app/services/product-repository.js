import Service, { service } from '@ember/service';
import { transformListToJsonApi, transformSingleToJsonApi } from '../utils/transform-to-json-api';

/**
 * ProductRepository - All product data operations in one place
 *
 * Encapsulates:
 * - Loading (findRecord, query, findAll)
 * - Creating (createRecord + save)
 * - Updating (save with rollback)
 * - Deleting (destroyRecord)
 */
export default class ProductRepositoryService extends Service {
  @service store;
  @service router;

  /**
   * Load all products (cached)
   * Uses store.findAll() - cached, no network on second call
   */
  async findAll() {
    return await this.store.findAll('product');
  }

  /**
   * Load one product by ID
   * Plain fetch + store.push() - simple and reliable
   *
   * @param {string|number} id - Product ID
   * @param {Object} options - { reload: true } to force fresh load
   * @returns {Promise<ProductModel>}
   */
  async findRecord(id, options = {}) {
    const idStr = String(id);

    if (options.reload) {
      return this._fetchSingleRecord(idStr);
    }

    // Try cache first (store.peekRecord is a safe sync lookup)
    // eslint-disable-next-line warp-drive/no-legacy-request-patterns
    const cached = this.store.peekRecord('product', idStr);
    if (cached) {
      return cached;
    }

    return this._fetchSingleRecord(idStr);
  }

  /**
   * Fetch a single product from API
   * @private
   */
  async _fetchSingleRecord(id) {
    const baseUrl = this.getBaseUrl();
    const url = `${baseUrl}products/${id}`;

    // eslint-disable-next-line warp-drive/no-external-request-patterns
    const response = await fetch(url);
    if (!response.ok) {
      throw { message: 'Product not found', status: 404 };
    }

    const plainJson = await response.json();
    const jsonApi = transformSingleToJsonApi(plainJson, 'product');

    this.store.push(jsonApi);
    // eslint-disable-next-line warp-drive/no-legacy-request-patterns
    return this.store.peekRecord('product', String(id));
  }

  /**
   * Query with filters and pagination
   * Plain fetch + store.push() transformation
   *
   * @param {Object} params - { q, limit, skip }
   * @returns {Promise<{products, total, skip, limit}>}
   */
  async query(params = {}) {
    const baseUrl = this.getBaseUrl();
    let url = `${baseUrl}products`;

    if (params.q && params.q.trim()) {
      url = `${baseUrl}products/search?q=${encodeURIComponent(params.q)}&limit=${params.limit || 10}&skip=${params.skip || 0}`;
    } else {
      url = `${baseUrl}products?limit=${params.limit || 10}&skip=${params.skip || 0}`;
    }

    // eslint-disable-next-line warp-drive/no-external-request-patterns
    const response = await fetch(url);
    const plainJson = await response.json();

    // Transform to JSON:API and push into store
    const jsonApi = transformListToJsonApi(
      plainJson.products || [],
      'product',
      { total: plainJson.total, skip: params.skip || 0, limit: params.limit || 10 }
    );

    // Push all records into the store
    this.store.push(jsonApi);

    // Return model instances from the store
    // eslint-disable-next-line warp-drive/no-legacy-request-patterns
    const products = jsonApi.data.map(item => this.store.peekRecord('product', item.id));

    return {
      products,
      total: plainJson.total || 0,
      skip: params.skip || 0,
      limit: params.limit || 10,
    };
  }

  /**
   * Create new product
   *
   * @param {Object} attributes - { title, price, description }
   * @returns {Promise<ProductModel>}
   */
  async create(attributes) {
    try {
      const product = this.store.createRecord('product', attributes);
      await product.save();
      return product;
    } catch (error) {
      throw {
        message: 'Failed to create product',
        error,
      };
    }
  }

  /**
   * Update existing product
   * With automatic rollback on failure
   *
   * @param {ProductModel} product - The model instance
   * @param {Object} attributes - Updated fields
   * @returns {Promise<ProductModel>}
   */
  async update(product, attributes) {
    // Store original state for rollback
    const originalState = product.getProperties(Object.keys(attributes));

    try {
      // Apply changes to the model
      Object.assign(product, attributes);

      // Save to API
      await product.save();

      return product;
    } catch (error) {
      // Rollback changes if save fails
      product.setProperties(originalState);

      throw {
        message: 'Failed to update product',
        error,
      };
    }
  }

  /**
   * Delete product
   *
   * @param {ProductModel} product - The model instance
   * @returns {Promise<void>}
   */
  async delete(product) {
    try {
      await product.destroyRecord();
    } catch (error) {
      throw {
        message: 'Failed to delete product',
        error,
      };
    }
  }

  /**
   * Load product with relationships
   * Resolves async relationships in the route for simpler templates
   *
   * @param {string|number} id - Product ID
   * @returns {Promise<{product, reviews}>}
   */
  async findWithRelationships(id) {
    const product = await this.findRecord(id);

    // Resolve async relationships
    const reviews = await product.reviews;

    return { product, reviews };
  }

  // Helper: Get base API URL
  getBaseUrl() {
    const baseUrl = this.store.baseUrl || 'https://dummyjson.com/';
    return baseUrl.endsWith('/') ? baseUrl : `${baseUrl}/`;
  }
}
