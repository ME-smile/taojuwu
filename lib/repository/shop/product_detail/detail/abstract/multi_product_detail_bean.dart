/*
 * @Description: 多商品的基类
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:08:03
 * @LastEditTime: 2020-11-05 10:03:44
 */
import 'package:taojuwu/repository/shop/product_detail/abstract/abstract_prodcut_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/abstract/single_product_detail_bean.dart';

abstract class MultiProductDetailBean extends AbstractProductDetailBean {
  List<SingleProductDetailBean> goodsList;
}
