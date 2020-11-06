/*
 * @Description: 多商品的基类
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:08:03
 * @LastEditTime: 2020-11-05 14:32:14
 */
import 'package:taojuwu/repository/shop/product_detail/abstract/abstract_base_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/abstract/base_product_detail_bean.dart';

import 'single_product_detail_bean.dart';

abstract class MultiProductDetailBean extends BaseProductDetailBean {
  List<SingleProductDetailBean> goodsList;

  //判断商品列表是否存在窗帘商品
  bool get hasCurtainProduct =>
      goodsList?.firstWhere((e) => e.productType != ProductType.EndProductType,
                  orElse: () => null) ==
              null
          ? false
          : true;

  double get totalPrice =>
      goodsList?.map((e) => e?.totalPrice ?? 0.0)?.reduce((a, b) => a + b);
}
