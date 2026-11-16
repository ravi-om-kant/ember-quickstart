import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { fn } from '@ember/helper';
import { on } from '@ember/modifier';

export default class extends Component {
  @tracked currentPerson;
  
  showPerson = (person) => {
    this.currentPerson = person;
  };

  isCurrentPerson = (person) => {
    return this.currentPerson == person;
  };

  <template>
    {{yield}}
    <h2>{{@name}} from {{@comName}}</h2>
    {{!-- {{#each @people as |people|}}
      <li>{{people}}</li>
    {{/each}} --}}

    {{#each @people as |people|}}
      <li>
        <button
          type="button"
          {{on "click" (fn this.showPerson people)}}
        >{{people}}</button>
        {{#if (this.isCurrentPerson people)}}
          ⬅️
        {{/if}}
      </li>
    {{/each}}
  </template>
}


// import Component from '@glimmer/component';
// import { tracked } from '@glimmer/tracking';

// export default class extends Component{
//   @tracked isPerson;

//   <template>
//   {{ yield }}

//   <h2>{{@title}}</h2>
//   <ol>
//     {{#each @people as |people|}}
//       <li>{{people}}</li>
//     {{/each}}
//   </ol>
// </template>

// }
