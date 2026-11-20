/**
 * Transform plain JSON response to JSON:API format
 * DummyJSON returns: { products: [...] } or { id, title, ... }
 * JSON:API expects: { data: [{ type, id, attributes }] } or { data: { type, id, attributes } }
 */

function extractAttributes(data) {
  const { id, ...attributes } = data;
  return attributes;
}

export function transformSingleToJsonApi(data, type) {
  if (!data || !data.id) {
    return { data: null };
  }

  return {
    data: {
      type,
      id: String(data.id),
      attributes: extractAttributes(data),
    },
  };
}

export function transformListToJsonApi(items, type, meta = {}) {
  if (!Array.isArray(items)) {
    return { data: [] };
  }

  return {
    data: items.map((item) => {
      if (!item.id) return null;

      return {
        type,
        id: String(item.id),
        attributes: extractAttributes(item),
      };
    }).filter(Boolean),
    meta: Object.keys(meta).length > 0 ? meta : undefined,
  };
}
