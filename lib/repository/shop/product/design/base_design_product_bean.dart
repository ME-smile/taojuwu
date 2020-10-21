/*
 * @Description: 软装方案 场景设计商品的基类
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:22:16
 * @LastEditTime: 2020-10-21 15:46:55
 */

import 'package:taojuwu/repository/shop/product/abstract/multi_product_bean.dart';

class BaseDesignProductBean extends MultiProductBean {
  BaseDesignProductBean.fromJson(Map<String, dynamic> json)
      : super.fromJson(json);
}
