import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
// import { fn } from '@ember/helper';
import { on } from '@ember/modifier';
import { action } from '@ember/object';

export default class extends Component {
  @tracked lang = 'en';
  langArr = ['en', 'de', 'ind', 'es'];
  get gretting() {
    switch (this.lang) {
      case 'en':
        return 'Hello';
      // break;
      case 'de':
        return 'Hallo';
      case 'ind':
        return 'Namaste';
      case 'es':
        return 'Halo';
      default:
        return 'Pranam';
    }
  }

  @action
  handleChange(event){
    this.lang = event.target.value;
    console.log(this.lang)
  }
  <template>
    <h1>
      {{this.gretting}}, {{this.args.name}} - {{@comName}}
    </h1>

    <select {{on "change" this.handleChange}}>
      {{#each this.langArr as |lang|}}
        <option value={{lang}}>{{lang}}</option>
      {{/each}}
    </select>
  </template>
}
