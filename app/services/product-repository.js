/* eslint-disable warp-drive/no-ext */
/*
import Service from '@ember/service';
import config from '../config/environment';

const BASE = `${config.APP.API_HOST}products`;

export default class ProductRepositoryService extends Service {
  async list(q) {
    const url = q ? `${BASE}?q=${encodeURIComponent(q)}` : BASE;
    const response = await fetch(url);
    return response.json();
  }

  async get(id) {
    const response = await fetch(`${BASE}/${id}`);
    return response.json();
  }

  async update(id, changes) {
    const response = await fetch(`${BASE}/${id}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(changes),
    });
    return response.json();
  }

  async remove(id) {
    await fetch(`${BASE}/${id}`, { method: 'DELETE' });
  }
}
*/

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

  async list(q) {
    const url = q ? `${BASE}/search?q=${encodeURIComponent(q)}` : BASE;
    const { content } = await requestWithRetry(this.store, {
      url,
      method: 'GET',
      cacheOptions: RAW,
      headers: JSON_HEADERS,
    });
    return content;
  }

  async get(id) {
    const { content } = await requestWithRetry(this.store, {
      url: `${BASE}/${id}`,
      method: 'GET',
      cacheOptions: RAW,
    });
    return content;
  }

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

  async remove(id) {
    await this.store.request({
      url: `${BASE}/${id}`,
      method: 'DELETE',
      cacheOptions: RAW,
    });
  }
}
