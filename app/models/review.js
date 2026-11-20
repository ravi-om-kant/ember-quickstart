import Model, { attr, belongsTo } from '@warp-drive/legacy/model';

export default class ReviewModel extends Model {
  @attr('string') comment;
  @attr('number') rating;
  @attr('string') reviewerName;
  @attr('date') date;

  @belongsTo('product', { async: true, inverse: 'reviews' }) product;
}
