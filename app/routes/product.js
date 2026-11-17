// import Route from '@ember/routing/route';
import {service} from '@ember/service';
import AuthenticatedRoute from './authenticated';

export default class ProductRoute extends AuthenticatedRoute {
  @service productRepository;

  async model(params){
    try {
    return await this.productRepository.get(params.id);
    } catch (error) {
      console.error(`Failed to load the product: ${params.id}`,error.message)
      return {
        error: true,
        message: error.message || `Failed to load the product: ${params.id}`
      }
    }
  }
}
