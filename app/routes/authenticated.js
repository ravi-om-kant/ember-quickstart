import Route from '@ember/routing/route';
import { service } from '@ember/service';

export default class AuthenticatedRoute extends Route {
  @service session;
  @service router;

  beforeModel() {
    // Check if user is logged in
    if (!this.session.isLoggedIn) {
      console.log('Not authenticated, redirecting to login');
      this.router.transitionTo('login');
    }
  }
}
