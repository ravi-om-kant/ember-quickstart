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

  async model({ q }) {
    try {
      const data = await this.productRepository.list(q);
      return data || [];
    } catch (error) {
      console.error('Failed to load products:', error);
      return {
        error: true,
        message: 'Failed to load products. Please try again later.'
      };
    }
  }
}
