import { pageTitle } from 'ember-page-title';
import PeopleList from '../components/people-list';
import HelloComponent from '../components/hello-component';

<template>
  {{pageTitle "Scientists"}}
  <h2>List of Scientists</h2>
  {{!--
    <ul>
      {{#each @model as |sci|}}
        <li>{{sci}}</li>
      {{/each}}
    </ul>
    --}}

  <PeopleList @title="List of Scientists - Props" @people={{@model}} />

  <HelloComponent
    @name="Ravi"
    @comName="Scientists Component"
    @people={{@model}}
  />

  {{outlet}}
</template>
