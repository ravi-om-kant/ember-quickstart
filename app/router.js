import EmberRouter from '@embroider/router';
import config from 'ember-quickstart/config/environment';

export default class Router extends EmberRouter {
  location = config.locationType;
  rootURL = config.rootURL;
}

Router.map(function () {
  this.route('scientists');
  this.route('counter');
  this.route('products');
  this.route('product', {path: '/products/:id'});
  this.route('login');
  this.route('authenticated');
});
