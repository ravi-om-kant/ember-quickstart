import Model, { attr, belongsTo, hasMany } from '@warp-drive/legacy/model';

export default class ProductModel extends Model {
  @attr('string') title;
  @attr('string') description;
  @attr('number') price;
  @attr('number') rating;
  @attr('number') stock;
  @attr('string') category;
  @attr('string') thumbnail;

  @belongsTo('category', { async: false, inverse: 'products' }) categoryModel;
  @hasMany('review', { async: true, inverse: 'product' }) reviews;

  get priceDisplay() {
    return `$${this.price.toFixed(2)}`;
  }
}
