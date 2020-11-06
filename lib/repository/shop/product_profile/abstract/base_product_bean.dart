/*
 * @Description: 商品列表数据模型
 * @Author: iamsmiling
 * @Date: 2020-11-05 10:23:34
 * @LastEditTime: 2020-11-05 10:36:03
 */
import 'package:taojuwu/repository/shop/product_profile/abstract/abstract_product_bean.dart';

class BaseProductBean extends AbstactProductBean {
  int count = 1;
  double price;
  double marketPrice;
  String cover;
  double name;
  String unit;
  int id;
  int type;
  bool get isPromotionalProduct => marketPrice != 0 && price < marketPrice;
}
