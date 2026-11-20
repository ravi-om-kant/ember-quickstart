import Component from '@glimmer/component';
import { trackedObject } from '@ember/reactive/collections';
import { action } from '@ember/object';
import { fn } from '@ember/helper';
import { on } from '@ember/modifier';

export default class ObjectTracked extends Component {
  setting = trackedObject({
    theme: 'dark',
    fontSize: 14,
    notification: true,
  });

  @action
  setTheme(newTheme) {
    this.setting = newTheme;
  }

  @action
  setNewSetting(key, value) {
    this.setting[key] = value;
  }
  get themeText() {
    return this.setting.theme === 'dark' ? 'light' : 'dark';
  }
  <template>
    {{yield}}
    {{@setting.theme}}
    <p>Theme: {{this.setting.theme}}</p>
    <p>Font Size: {{this.setting.fontSize}}</p>
    <div style="display: grid">
      <label>
        Notifications:
        <input type="checkbox" checked={{this.setting.notification}} />
      </label>

      <label>
        Toggle Theme:
        <button
          type="button" {{on "click" (fn this.setNewSetting "theme" this.themeText)}}
        >{{this.themeText}}</button>
      </label>
    </div>
  </template>
}
