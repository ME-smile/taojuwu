/*
 * @Description: 成品商品的具体实现类
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:18:26
 * @LastEditTime: 2020-10-27 16:41:40
 */
import 'base_end_product_bean.dart';

class ConcreteEndProductBean extends BaseEndProductBean {
  ConcreteEndProductBean.fromJson(Map<String, dynamic> json)
      : super.fromJson(json);

  @override
  double get totalPrice => 0.0;

  @override
  Future addToCart() {
    print(cartArgs);
    return Future.value(false);
    // throw UnimplementedError();
  }

  @override
  Future buy() {
    throw UnimplementedError();
  }

  @override
  get cartArgs {
    return {
      'sku_id': '$skuId',
      'goods_id': '$goodsId',
      'goods_name': '$goodsName',
      'shop_id': '$shopId',
      'picture': '$picture',
      'num': '$count',
      'estimated_price': totalPrice
    };
  }

  @override
  Map get attrArgs => {};
}
