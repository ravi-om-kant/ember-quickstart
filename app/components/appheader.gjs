import Component from '@glimmer/component';
import { service } from '@ember/service';
import { on } from '@ember/modifier';
import { LinkTo } from '@ember/routing';

export default class AppHeaderComponent extends Component {
  @service session;
  @service router;

  handleLogout = () => {
    console.log('Logging out...');
    this.session.logout();
    this.router.transitionTo('login'); 
  };

  <template>
    <header class="app-header">
      <div class="header-left">
        <h1>My App</h1>
      </div>

      <nav class="header-nav">
        <LinkTo @route="products">Products</LinkTo>
      </nav>

      <div class="header-right">
        {{#if this.session.isLoggedIn}}
          <span class="user-name">👤 {{this.session.user.firstName}}</span>
          <button class="btn-logout" type="button" {{on "click" this.handleLogout}}>
            🚪 Logout
          </button>
        {{/if}}
      </div>
    </header>
  <style>
    .app-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      background-color: #2c3e50;
      color: white;
      padding: 16px 24px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    .header-left h1 {
      margin: 0;
      font-size: 24px;
    }

    .header-nav {
      display: flex;
      gap: 24px;
    }

    .header-nav a {
      color: white;
      text-decoration: none;
      font-weight: 500;
    }

    .header-nav a:hover {
      color: #3498db;
    }

    .header-right {
      display: flex;
      align-items: center;
      gap: 16px;
    }

    .user-name {
      font-size: 14px;
    }

    .btn-logout {
      background-color: #e74c3c;
      color: white;
      border: none;
      padding: 8px 16px;
      border-radius: 4px;
      cursor: pointer;
      font-weight: bold;
    }

    .btn-logout:hover {
      background-color: #c0392b;
    }
  </style>
  </template>

}
