import Controller from '@ember/controller';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';

export default class ProductsController extends Controller {
  queryParams = ['q', 'limit', 'skip'];
  @tracked q = '';
  @tracked skip = 0;
  @tracked limit = 10;

  get hasSearchTerm() {
    return this.q && this.q.trim().length > 0;
  }

  get isFirstPage() {
    return Number(this.skip) === 0;
  }

  get isLastPage() {
    return Number(this.skip) + Number(this.limit) >= (this.model?.total ?? 0);
  }

  get rangeStart() {
    return Number(this.skip) + 1;
  }

  get rangeEnd() {
    return Number(this.skip) + Number(this.limit);
  }

  @action
  updateQuery(event) {
    console.log(event.target.value);
    this.q = event.target.value;
    this.skip = 0;
  }

  @action
  clearSearch() {
    console.log('claear');
    this.q = '';
    this.skip = 0;
  }

  @action
  updateLimit(event) {

    console.log(event.target.value)
    this.limit = Number(event.target.value);
    this.skip = 0;
  }

  @action
  nextPage() {
    this.skip = Number(this.skip) + Number(this.limit);

    console.log(this.skip)
  }

  @action
  previousPage() {
    this.skip = Math.max(0, Number(this.skip) - Number(this.limit));
    console.log(this.skip);

  }
}
