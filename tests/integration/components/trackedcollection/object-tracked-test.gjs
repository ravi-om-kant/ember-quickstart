import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-quickstart/tests/helpers';
import { render } from '@ember/test-helpers';
import ObjectTracked from 'ember-quickstart/components/trackedcollection/object-tracked';

module('Integration | Component | trackedcollection/object-tracked', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders', async function (assert) {
    // Updating values is achieved using autotracking, just like in app code. For example:
    // class State { @tracked myProperty = 0; }; const state = new State();
    // and update using state.myProperty = 1; await rerender();
    // Handle any actions with function myAction(val) { ... };

    await render(<template><ObjectTracked /></template>);

    assert.dom().hasText('');

    // Template block usage:
    await render(<template>
      <ObjectTracked>
        template block text
      </ObjectTracked>
    </template>);

    assert.dom().hasText('template block text');
  });
});
