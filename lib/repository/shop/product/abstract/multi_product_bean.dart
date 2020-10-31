/*
 * @Description: 多商品的基类
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:08:03
 * @LastEditTime: 2020-10-30 16:11:15
 */
import 'package:taojuwu/repository/shop/product/abstract/abstract_base_product_bean.dart';
import 'package:taojuwu/repository/shop/product/abstract/single_product_bean.dart';

abstract class MultiProductBean extends AbstractBaseProductBean {
  List<SingleProductBean> goodsList;
}
