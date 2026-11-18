import Service, { service } from '@ember/service';
import { SkipCache } from '@warp-drive/core/types/request';
import config from '../config/environment';

// const BASE = `${config.APP.API_HOST}/products`;
const BASE = new URL('products', config.APP.API_HOST).href;
const BEARER_TOKEN = localStorage.getItem('token');
const JSON_HEADERS = new Headers({
  'Content-Type': 'application/json',
  Authorization: `Bearer ${BEARER_TOKEN}`,
});
const RAW = { [SkipCache]: true };

async function requestWithRetry(store, options) {
  for (let attempt = 0; ; attempt++) {
    try {
      return await store.request(options);
    } catch (error) {
      if (
        options.method !== 'GET' ||
        !(error instanceof TypeError) ||
        attempt >= 2
      ) {
        throw error;
      }
      await new Promise((resolve) => setTimeout(resolve, 300 * 2 ** attempt));
    }
  }
}

export default class ProductRepositoryService extends Service {
  @service store;

  /**
   * Search for products by query term
   * API: /products/search?q=phone
   */
  async list(q, limit, skip) {
    const url = q ? `${BASE}/search?q=${encodeURIComponent(q)}&limit=${limit}&skip=${skip}` : BASE;
    const { content } = await requestWithRetry(this.store, {
      url,
      method: 'GET',
      cacheOptions: RAW,
      headers: JSON_HEADERS,
    });
    return content;
  }

  /**
   * Get products with pagination
   * API: /products?limit=10&skip=0
   */
  async listWithPagination(limit, skip) {
    const url = `${BASE}?limit=${limit}&skip=${skip}`;
    const { content } = await requestWithRetry(this.store, {
      url,
      method: 'GET',
      cacheOptions: RAW,
      headers: JSON_HEADERS,
    });
    return content;
  }

  /**
   * Get a single product by ID
   * API: /products/1
   */
  async get(id) {
    const { content } = await requestWithRetry(this.store, {
      url: `${BASE}/${id}`,
      method: 'GET',
      cacheOptions: RAW,
    });
    return content;
  }

  /**
   * Update a product
   * API: PUT /products/1
   */
  async update(id, changes) {
    const { content } = await this.store.request({
      url: `${BASE}/${id}`,
      method: 'PUT',
      cacheOptions: RAW,
      headers: JSON_HEADERS,
      body: JSON.stringify(changes),
    });
    return content;
  }

  /**
   * Delete a product
   * API: DELETE /products/1
   */
  async remove(id) {
    await this.store.request({
      url: `${BASE}/${id}`,
      method: 'DELETE',
      cacheOptions: RAW,
    });
  }
}
