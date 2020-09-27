/*
 * @Description:窗帘商品相对成品多有一个ordergoodsmeaure 测装
 * @Author: iamsmiling
 * @Date: 2020-09-27 16:07:25
 * @LastEditTime: 2020-09-27 16:10:02
 */
import 'package:taojuwu/repository/order/order_detail_model.dart';
import 'package:taojuwu/viewmodel/goods/binding/base_goods_binding.dart';

mixin CurtainGoodsBinding on BaseGoodsBinding {
  OrderGoodsMeasure measureData;
}
