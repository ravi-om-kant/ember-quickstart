import Model, { attr, hasMany } from '@warp-drive/legacy/model';

export default class CategoryModel extends Model {
  @attr('string') name;
  @attr('string') description;

  @hasMany('product', { async: false, inverse: 'categoryModel' }) products;
}
