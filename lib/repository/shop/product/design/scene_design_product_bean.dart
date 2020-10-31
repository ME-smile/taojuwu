/*
 * @Description: 场景设计商品
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:24:10
 * @LastEditTime: 2020-10-28 13:08:14
 */
import 'package:taojuwu/repository/shop/product/abstract/abstract_base_product_bean.dart';

import 'base_design_product_bean.dart';

class SceneDesignProductBean extends BaseDesignProductBean {
  SceneDesignProductBean.fromJson(Map<String, dynamic> json)
      : super.fromJson(json);

  @override
  ProductType get productType => ProductType.SceneDesignProductType;
}
