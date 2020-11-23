/*
 * @Description: 选品时的目标选品
 * @Author: iamsmiling
 * @Date: 2020-11-18 13:51:19
 * @LastEditTime: 2020-11-20 10:43:51
 */
import 'package:taojuwu/repository/order/order_detail_model.dart';

class TargetProductHolder {
  static int status; //0表示未选品 1表示已经选品
  static OrderGoodsMeasureData measureData;
  static int goodsType; //类型
  static String categoryName; //类型名字
  static String height;

  static void clear() {
    status = null;
    measureData = null;
    goodsType = null;
    categoryName = null;
    height = null;
  }
}
