import { useLegacyStore } from '@warp-drive/legacy';
import { JSONAPICache } from '@warp-drive/json-api';
import { transformSingleToJsonApi, transformListToJsonApi } from '../utils/transform-to-json-api';

/**
 * WarpDrive Store with DummyJSON Handler
 *
 * This handler transforms DummyJSON's plain JSON responses into JSON:API format
 * so the store can work with models properly.
 *
 * DummyJSON: { products: [...], total: 100 }  or  { id: 1, title: "...", ... }
 * JSON:API:  { data: [{ type: 'product', id, attributes }], meta: { total } }
 */

const Store = useLegacyStore({
  linksMode: false,
  cache: JSONAPICache,
  handlers: [
    {
      match: (request) => request.url.includes('/products'),
      request: async (context) => {
        // eslint-disable-next-line warp-drive/no-external-request-patterns
        const response = await fetch(context.request.url, {
          method: context.request.method || 'GET',
          headers: context.request.headers,
          body: context.request.body,
        });

        if (!response.ok) {
          throw new Error(`HTTP ${response.status}`);
        }

        const plainJson = await response.json();
        let jsonApiData;

        // Determine if it's a list or single response
        if (plainJson.products && Array.isArray(plainJson.products)) {
          // List response: { products: [...], total: N, skip: 0, limit: 10 }
          const { total, skip, limit } = plainJson;
          jsonApiData = transformListToJsonApi(plainJson.products, 'product', {
            total,
            skip,
            limit,
          });
        } else if (plainJson.id !== undefined && !Array.isArray(plainJson)) {
          // Single response: { id: 1, title: "...", ... }
          jsonApiData = transformSingleToJsonApi(plainJson, 'product');
        } else {
          console.error('Unexpected response format:', plainJson);
          throw new Error('Invalid API response format');
        }

        return {
          status: response.status,
          headers: response.headers,
          content: jsonApiData,
        };
      },
    },
  ],
  schemas: [],
});

export default Store;
