/*
 * @Description: 卷帘商品
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:13:51
 * @LastEditTime: 2020-10-31 16:11:13
 */

import 'package:taojuwu/repository/shop/product/abstract/abstract_base_product_bean.dart';

import 'base_curtain_product_bean.dart';

class RollingCurtainProductBean extends BaseCurtainProductBean {
  RollingCurtainProductBean.fromJson(Map<String, dynamic> json)
      : super.fromJson(json);

  @override
  double get totalPrice => unitPrice * area;

  // @override
  // Future addToCart(BuildContext context) {
  //   print(cartArgs);
  //   return Future.value(false);
  // }

  // @override
  // Future buy(BuildContext context) {
  //   return Future.value(false);
  // }

  // @override
  // get cartArgs => {
  //       // 'measure_data': mesaureDataArg,
  //       // 'wc_attr': attrArgs,
  //       // 'sku_id': '$skuId',
  //       // 'goods_id': '$goodsId',
  //       // 'goods_name': '$goodsName',
  //       // 'shop_id': '$shopId',
  //       // 'picture': '$picture',
  //       // 'num': '$count',
  //       // 'estimated_price': totalPrice,
  //       // '13': attrList?.last?.toJson(),

  //       'wc_attr': jsonEncode(attrArgs),
  //       'measure_id': measureData?.id,
  //       'estimated_price': totalPrice,
  //       'client_uid': clientId,
  //       'is_shade': 1,
  //       'cart_detail': jsonEncode({
  //         'sku_id': '$skuId',
  //         'goods_id': '$goodsId',
  //         'goods_name': '$goodsName',
  //         'shop_id': '$shopId',
  //         'price': '$price',
  //         'picture': '$picture',
  //         'num': '$count',
  //       })
  //     };

  @override
  ProductType get productType => ProductType.RollingCurtainProductType;

  @override
  String get detailDescription => '';
}
