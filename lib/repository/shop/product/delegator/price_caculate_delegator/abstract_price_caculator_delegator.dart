/*
 * @Description: //价格结算器 代理
 * @Author: iamsmiling
 * @Date: 2020-10-20 17:54:34
 * @LastEditTime: 2020-10-21 13:27:58
 */

import 'package:taojuwu/repository/shop/product/abstract/base_product_bean.dart';

abstract class AbstractPriceCaculateDelegator {
  BaseProductBean productBean;
  double get totalPrice;
}
