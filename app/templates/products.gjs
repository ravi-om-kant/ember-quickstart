import { pageTitle } from 'ember-page-title';
import Products from '../components/products.gjs';
import AppHeaderComponent from '../components/appheader.gjs';

<template>
  {{pageTitle "Products"}}
  <AppHeaderComponent />
  <Products @data={{@model}} />
  {{outlet}}
</template>
// import { helper } from '@ember/component/helper';
// import config from '../config/environment';

// const getConfig = helper(() => config);

// <template>
//   {{getConfig.APP.API_HOST}}  // ✅ Parentheses to call it
// </template>
