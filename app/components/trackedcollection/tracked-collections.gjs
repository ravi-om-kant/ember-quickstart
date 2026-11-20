import Component from '@glimmer/component';
import { trackedArray, trackedObject } from '@ember/reactive/collections';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import PeopleList from '../people-list.gjs';
import ObjectTracked from '../trackedcollection/object-tracked.gjs';
import MapTracked from '../trackedcollection/map-tracked.gjs';

export default class TrackedCollections extends Component {
  people = trackedArray(['Ram', 'Lakashman']);
  setting = trackedObject({
    theme: 'dark',
    fontSize: 14,
    notification: true,
  });
  @tracked name = '';

  addPeople = () => {
    this.people.push(this.name);
    this.name = '';
  };

  removePeople = () => {
    const index = this.people.indexOf(this.name);
    if (index !== -1) {
      this.people.splice(index, 1);
    }
  };
  @action
  handleChange(event) {
    this.name = event.target.value;
  }
  <template>
    {{@title}}
    <input
      name="name"
      value={{this.name}}
      placeholder="Enter the name"
      {{on "change" this.handleChange}}
    />
    <button type="button" {{on "click" this.addPeople}}>Add Person</button>
    <button type="button" {{on "click" this.removePeople}}>Remove Person</button>
    <hr />
    <PeopleList @title="Composotion component for list">
      <:ss><hr /></:ss>
      <:header><h3>Composition Impl with array of list</h3></:header>
      <:default><p>default</p></:default>
      <:item>
        {{#each this.people as |p|}}
          <li>{{p}}</li>
        {{/each}}
      </:item>
      <:footer><button type="button">OK</button></:footer>
    </PeopleList>
    <hr />
    <ObjectTracked @setting={{this.setting}}>
      <:default><h1>Object Tracked by Yield:
          {{"""<:default>{{yield}}</:default>"""}}</h1></:default>
    </ObjectTracked>
    <hr />
    <MapTracked>
      <:default><h1>MapMapTracked by Yield: </h1></:default>
    </MapTracked>
  </template>
}
