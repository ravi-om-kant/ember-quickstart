import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { on } from '@ember/modifier';
import { action } from '@ember/object';

export default class CounterComponent extends Component {
  @tracked count = 0;

  increment = () => {
    this.count++;
  };

  @action
  decrement() {
    this.count--;
  }

  <template>
    <p>{{this.count}}</p>

    <button type="button" {{on "click" this.increment}}>+</button>
    <button type="button" {{on "click" this.decrement}}>-</button>
  </template>
}

// import Component from "@glimmer/component";
// import { tracked } from '@glimmer/tracking';
// import { on } from '@ember/modifier';
// import { fn } from '@ember/helper';
// import { action } from '@ember/object';

// export default class extends Component{
//   @tracked count = 0;

//   @action
//   increment(){
//     this.count++;
//   }

//   @action
//   decrement(){
//     this.count--;
//   }
//   <template>
//     {{!-- {{yield}} --}}
//     <h2>{{@name}} from {{@comName}}</h2>
//     <p>Count is: {{this.count}}</p>
//     <button type="button" {{on "click" (fn this.increment)}}>Increment</button>
//     <button type="button" {{on "click" (fn this.decrement)}}>Decrement</button>
//   </template>

// }

// import { fn } from '@ember/helper';
// import { on } from '@ember/modifier';

// function showNumber(num){
//   console.error(`On click event learn in emmer ${num}`)
// }

// <template>
//   {{yield}}
//   <h2>{{@title}}-</h2>
//   <ul>
//     {{#each @number as |n|}}
//       <li>
//         <button type="button" {{on "click" (fn showNumber n) }}>{{n}}</button>
//       </li>
//     {{/each}}
//   </ul>
// </template>
