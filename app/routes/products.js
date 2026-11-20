import AuthenticatedRoute from './authenticated';
import { service } from '@ember/service';

export default class ProductsRoute extends AuthenticatedRoute {
  @service productRepository;

  queryParams = {
    q: { refreshModel: true },
    limit: { refreshModel: true },
    skip: { refreshModel: true },
  };

  /**
   * Load products using repository.query()
   *
   * Returns array of ProductModel instances (live, cached, shared)
   * Changes to any product are visible everywhere
   */
  async model({ q = '', limit = 10, skip = 0 }) {
    return await this.productRepository.query({
      q,
      limit: parseInt(limit),
      skip: parseInt(skip),
    });
  }

  resetController(controller, isExiting) {
    if (isExiting) {
      controller.q = '';
      controller.skip = 0;
      controller.limit = 10;
    }
  }
}
