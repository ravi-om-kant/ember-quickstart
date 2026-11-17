import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { service } from '@ember/service';
import { on } from '@ember/modifier';
// import { fn } from '@ember/helper';

export default class LoginFormComponent extends Component {
  @service session;
  @service router;

  @tracked email = 'emilys';
  @tracked pass = 'emilyspass';
  @tracked error = null;
  @tracked isLoading = false;

  handleLogin = async (event) => {
    event.preventDefault();
    this.isLoading = true;
    this.error = null;

    // now i am using session which i have created in service to access loginCred function;
    const result = await this.session.loginWithCred(this.email, this.pass);
    if (!result.success) {
      this.error = result.error?.message;
    }else{
      this.router.transitionTo('products');

    }
    // used a service of route if logedin then go to products routes.
    this.isLoading = false;
  };
  handleEmailChange = (event) => {
    this.email = event.target.value;
  };

  handlePasswordChange = (event) => {
    this.pass = event.target.value;
  };

  <template>
    {{yield}}
    <form {{on "submit" this.handleLogin}}>
      {{#if this.error}}
        <div class="error">{{this.error}}</div>
      {{/if}}
      <div class="form-group">
        <label>Email/Username</label>
        <input
          type="text"
          value={{this.email}}
          {{on "change" this.handleEmailChange}}
        />
      </div>
      <div class="form-group">
        <label>Password</label>
        <input
          type="text"
          value={{this.pass}}
          {{on "change" this.handlePasswordChange}}
        />
      </div>
      <button type="submit" disabled={{this.isLoading}}>
        {{#if this.isLoading}}
          Loagging in...
        {{else}}
          Log in
        {{/if}}
      </button>
    </form>

    <style>
      form {
        display: flex;
        flex-direction: column;
        gap: 16px;
      }

      .form-group {
        display: flex;
        flex-direction: column;
      }

      .form-group label {
        margin-bottom: 4px;
        font-weight: bold;
      }

      .form-group input {
        padding: 8px;
        border: 1px solid #ddd;
        border-radius: 4px;
      }

      button {
        padding: 10px;
        background-color: #3498db;
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
      }

      button:hover:not(:disabled) {
        background-color: #2980b9;
      }

      button:disabled {
        opacity: 0.6;
        cursor: not-allowed;
      }

      .error {
        background-color: #f8d7da;
        color: #721c24;
        padding: 12px;
        border-radius: 4px;
      }
    </style>
  </template>
}
