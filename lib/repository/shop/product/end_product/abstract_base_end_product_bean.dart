/*
 * @Description: 成品商品的抽象类
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:15:28
 * @LastEditTime: 2020-10-21 15:47:25
 */

import 'package:taojuwu/repository/shop/product/abstract/single_product_bean.dart';

abstract class AbstractBaseEndProductBean extends SingleProductBean {
  AbstractBaseEndProductBean.fromJson(Map<String, dynamic> json)
      : super.fromJson(json);
}
