/*
 * @Description: 软装方案
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:23:18
 * @LastEditTime: 2020-10-29 11:28:15
 */
import 'package:taojuwu/repository/shop/product/abstract/abstract_base_product_bean.dart';
import 'package:taojuwu/repository/shop/product/design/base_design_product_bean.dart';

class SoftDesignProductBean extends BaseDesignProductBean {
  // if (e['goods_type'] == 0) {}

  SoftDesignProductBean.fromJson(Map<String, dynamic> json)
      : super.fromJson(json);

  @override
  ProductType get productType => ProductType.SoftDesignProductType;
}
