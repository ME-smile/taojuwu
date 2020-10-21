/*
 * @Description: 软装方案 场景 商品的基类
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:20:43
 * @LastEditTime: 2020-10-21 15:46:40
 */
import 'package:taojuwu/repository/shop/product/abstract/multi_product_bean.dart';

abstract class AbstractDesignProductBean extends MultiProductBean {
  AbstractDesignProductBean.fromJson(Map<String, dynamic> json)
      : super.fromJson(json);
}
