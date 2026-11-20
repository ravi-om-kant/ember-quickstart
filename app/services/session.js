import Service from '@ember/service';
import { service } from '@ember/service';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import config from '../config/environment';

const API_HOST = config.APP.API_HOST.endsWith('/')
  ? config.APP.API_HOST
  : `${config.APP.API_HOST}/`;
const BASE = `${API_HOST}auth`;

export default class SessionService extends Service {
  @service router;

  @tracked user = null;
  @tracked token = null;
  @tracked isLoggedIn = false;

  get isAuthenticated() {
    return !!this.user;
  }

  @action
  login(user) {
    this.user = user;
    this.router.transitionTo('/products');
  }
  // Login - called from routes/components
  @action
  async loginWithCred(email, pass) {
    try {
      // Use plain fetch for auth (not products API)
      // eslint-disable-next-line warp-drive/no-external-request-patterns
      const response = await fetch(`${BASE}/login`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          username: email ?? 'emilys',
          password: pass ?? 'emilyspass',
        }),
        credentials: 'include',
      });

      if (!response.ok) {
        throw new Error('Login failed');
      }

      const data = await response.json();

      // Store user data
      this.user = {
        id: data.id,
        username: data.username,
        email: data.email,
        firstName: data.firstName,
        lastName: data.lastName,
      };

      this.token = data.accessToken;
      this.isLoggedIn = true;

      localStorage.setItem('user', JSON.stringify(this.user));
      localStorage.setItem('token', JSON.stringify(this.token));

      this.router.transitionTo('/products');

      return { success: true, user: this.user };
    } catch (error) {
      return { success: false, error: error.message };
    }
  }

  @action
  logout() {
    this.user = null;
    this.router.transitionTo('/login');
  }

  @action
  logoutCred(){
    this.user = null;
    this.token = null;
    this.isLoggedIn = false;
    localStorage.clear();
  }
}
