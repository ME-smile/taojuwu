/*
 * @Description: 购物车商品
 * @Author: iamsmiling
 * @Date: 2020-11-09 16:02:03
 * @LastEditTime: 2020-11-09 16:03:10
 */
import 'package:taojuwu/repository/shop/product_detail/abstract/abstract_base_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/detail/abstract/multi_product_detail_bean.dart';

class CartProductDetailBean extends MultiProductDetailBean {
  @override
  Map get attrArgs => throw UnimplementedError();

  @override
  get cartArgs => throw UnimplementedError();

  @override
  ProductType get productType => throw UnimplementedError();

  @override
  double get totalPrice => throw UnimplementedError();
}
