// import Route from '@ember/routing/route';
// import { service } from '@ember/service';

// export default class ProductsRoute extends Route {
//   @service productRepository;

//   queryParams = { q: { refreshModel: true } };

//   async model({ q }) {
//     try {
//       const data = await this.productRepository.list(q);
//       // Extract products array from API response
//       return data || [];
//     } catch (error) {
//       console.error('Failed to load products:', error);
//       // Return error object so template can display it
//       return {
//         error: true,
//         message: 'Failed to load products. Please try again later.',
//         type: error.message
//       };
//     }
//   }
// }
import AuthenticatedRoute from './authenticated';
import { service } from '@ember/service';

export default class ProductsRoute extends AuthenticatedRoute {
  @service productRepository;

  // These config options control query param behavior
  queryParams = {
    q: { refreshModel: true }, // Re-fetch when search changes
    limit: { refreshModel: true }, // Re-fetch when limit changes
    skip: { refreshModel: true }, // Re-fetch when pagination changes
  };

  async model({ q, limit, skip }) {
    try {
      // Build URL based on whether user is searching or browsing
      let apiResponse;

      if (q && q.trim()) {
        // Search: use the search endpoint
        apiResponse = await this.productRepository.list(q, limit, skip);
      } else {
        // Browse: use pagination endpoint
        apiResponse = await this.productRepository.listWithPagination(
          limit,
          skip,
        );
      }

      // Extract the products array and add metadata
      return {
        products: apiResponse.products || [],
        total: apiResponse.total || 0,
        skip: apiResponse.skip || 0,
        limit: limit,
      };
    } catch (error) {
      console.error('Failed to load products:', error);
      return {
        error: true,
        message: 'Failed to load products. Please try again later.',
        products: [],
      };
    }
  }

  // Clear search when user leaves the page
  resetController(controller, isExiting) {
    if (isExiting) {
      controller.q = '';
      controller.skip = 0;
      controller.limit = 10;
    }
  }
}
