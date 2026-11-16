import { pageTitle } from 'ember-page-title';
import CounterComponent from '../components/counter-component';

<template>
  {{pageTitle "Counter"}}
    <CounterComponent 
      @title="Counter"
      @number={{@model}}
    />
  {{outlet}}
</template>
