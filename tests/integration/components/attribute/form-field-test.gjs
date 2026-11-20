import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-quickstart/tests/helpers';
import { render } from '@ember/test-helpers';
import FormField from 'ember-quickstart/components/attribute/form-field';

module('Integration | Component | attribute/form-field', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders', async function (assert) {
    // Updating values is achieved using autotracking, just like in app code. For example:
    // class State { @tracked myProperty = 0; }; const state = new State();
    // and update using state.myProperty = 1; await rerender();
    // Handle any actions with function myAction(val) { ... };

    await render(<template><FormField /></template>);

    assert.dom().hasText('');

    // Template block usage:
    await render(<template>
      <FormField>
        template block text
      </FormField>
    </template>);

    assert.dom().hasText('template block text');
  });
});
