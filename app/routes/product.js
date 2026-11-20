import AuthenticatedRoute from './authenticated';
import { service } from '@ember/service';

export default class ProductRoute extends AuthenticatedRoute {
  @service productRepository;

  /**
   * Load product with relationships using repository.findWithRelationships()
   *
   * Returns:
   * - product: ProductModel instance (live, cached)
   * - reviews: Resolved array of ReviewModel instances
   *
   * Changes to product or reviews are visible everywhere
   */
  async model({ id }) {
    return await this.productRepository.findWithRelationships(id);
  }
}
