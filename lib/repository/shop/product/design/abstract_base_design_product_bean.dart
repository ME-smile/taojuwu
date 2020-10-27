/*
 * @Description: 软装方案 场景 商品的基类
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:20:43
 * @LastEditTime: 2020-10-22 16:48:39
 */
import 'package:taojuwu/repository/shop/product/abstract/multi_product_bean.dart';
import 'package:taojuwu/repository/shop/product/abstract/single_product_bean.dart';

abstract class AbstractDesignProductBean extends MultiProductBean {
  int id;
  String name;
  String desc;
  String room;
  String style;
  double totalPrice;
  double get marketPrice;
  String designName;
  String picture;
  List<SingleProductBean> goodsList;
}
