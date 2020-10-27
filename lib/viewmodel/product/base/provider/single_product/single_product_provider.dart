/*
 * @Description: 单商品
 * @Author: iamsmiling
 * @Date: 2020-10-20 18:10:18
 * @LastEditTime: 2020-10-27 14:20:19
 */
import 'package:taojuwu/repository/shop/product/abstract/single_product_bean.dart';
import 'package:taojuwu/viewmodel/product/base/provider/base_product_provider.dart';

abstract class SingleProductProvider extends BaseProductProvider {
  int goodsId;

  SingleProductBean get singleProductBean => (productBean as SingleProductBean);
}
