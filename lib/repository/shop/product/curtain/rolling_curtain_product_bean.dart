/*
 * @Description: 卷帘商品
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:13:51
 * @LastEditTime: 2020-10-26 14:03:28
 */
import 'base_curtain_product_bean.dart';

class RollingCurtainProductBean extends BaseCurtainProductBean {
  RollingCurtainProductBean.fromJson(Map<String, dynamic> json)
      : super.fromJson(json);

  @override
  double get totalPrice => unitPrice * area;

  @override
  Future addToCart() {
    // TODO: implement addToCart
    throw UnimplementedError();
  }

  @override
  Future buy() {
    // TODO: implement buy
    throw UnimplementedError();
  }

  @override
  // TODO: implement cartArgs
  Map<String, dynamic> get cartArgs => throw UnimplementedError();
}
