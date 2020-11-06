/*
 * @Description: 成品商品的抽象类
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:15:28
 * @LastEditTime: 2020-10-21 15:47:25
 */

import 'package:taojuwu/repository/shop/product_detail/abstract/single_product_detail_bean.dart';

abstract class AbstractBaseEndProductDetailBean
    extends SingleProductDetailBean {
  AbstractBaseEndProductDetailBean.fromJson(Map<String, dynamic> json)
      : super.fromJson(json);
}
