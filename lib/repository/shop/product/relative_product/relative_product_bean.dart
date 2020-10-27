/*
 * @Description: 相关商品 数据模型  同料商品
 * @Author: iamsmiling
 * @Date: 2020-10-22 16:28:55
 * @LastEditTime: 2020-10-27 16:13:11
 */
import 'package:taojuwu/repository/shop/product/abstract/base_product_bean.dart';

class RelativeProductBean extends BaseProductBean {
  RelativeProductBean.fromJson(Map<String, dynamic> json)
      : super.fromJson(json);

  @override
  double get totalPrice => 0.0;

  @override
  Future addToCart() {
    throw UnimplementedError();
  }

  @override
  Future buy() {
    // TODO: implement buy
    throw UnimplementedError();
  }

  @override
  // TODO: implement attrArgs
  Map get attrArgs => throw UnimplementedError();

  @override
  // TODO: implement cartArgs
  Map<String, dynamic> get cartArgs => throw UnimplementedError();
}
