/*
 * @Description: 软装方案
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:23:18
 * @LastEditTime: 2020-10-29 11:28:15
 */

import 'package:taojuwu/repository/shop/product_detail/abstract/abstract_base_product_detail_bean.dart';

import 'base_design_product_detail_bean.dart';

class SoftDesignProductDetailBean extends BaseDesignProductDetailBean {
  // if (e['goods_type'] == 0) {}

  SoftDesignProductDetailBean.fromJson(Map<String, dynamic> json)
      : super.fromJson(json);

  @override
  ProductType get productType => ProductType.SoftDesignProductType;
}
