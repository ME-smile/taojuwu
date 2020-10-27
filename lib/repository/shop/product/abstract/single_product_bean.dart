/*
 * @Description: 单商品的基类
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:06:20
 * @LastEditTime: 2020-10-22 17:07:21
 */

import 'base_product_bean.dart';

abstract class SingleProductBean extends BaseProductBean {
  SingleProductBean.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}
