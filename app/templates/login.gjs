import { pageTitle } from 'ember-page-title';
import LoginForm from '../components/login-form.gjs';

<template>
  {{pageTitle "Login"}}

  <div class="login-page">
    <h1>Login</h1>
    <LoginForm />
  </div>

  <style>
    .login-page {
      max-width: 400px;
      margin: 100px auto;
      padding: 24px;
      border: 1px solid #ddd;
      border-radius: 8px;
    }
  </style>
</template>
