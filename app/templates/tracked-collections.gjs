import { pageTitle } from 'ember-page-title';
import TrackedCollections from "../components/trackedcollection/tracked-collections.gjs";
// import ObjectTracked from '../components/trackedcollection/object-tracked.gjs';
<template>
  {{pageTitle "TrackedCollections"}}
  <TrackedCollections @title="TrackedCollections"/>
  {{!-- <ObjectTracked /> --}}
  {{outlet}}
</template>
