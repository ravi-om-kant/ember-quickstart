<template>
  {{yield}}
  <div class="form-field" ...attributes>
    {{#if (has-block "label")}}
      <label>{{yield to="label"}}</label>
    {{/if}}

    <div class="input-wrapper">
      {{yield to="input"}}
    </div>

    {{#if (has-block "error")}}
      <span class="error">{{yield to="error"}}</span>
    {{/if}}
  </div>
</template>
