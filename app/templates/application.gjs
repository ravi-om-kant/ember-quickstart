/*
import { pageTitle } from 'ember-page-title';
<template>
  {{pageTitle "EmberQuickstart"}}
    <h1>Hello</h1>
  {{outlet}}
</template>
*/
import { LinkTo } from '@ember/routing';

<template>
  <h1>PeopleTracker</h1>
  <nav>
    <LinkTo @route="counter">Counter</LinkTo>
    <LinkTo @route="products">All Products</LinkTo>
    <LinkTo @route="scientists">Scientists</LinkTo>
  </nav>
  {{outlet}}
</template>
