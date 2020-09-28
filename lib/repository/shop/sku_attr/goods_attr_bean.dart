/*
 * @Description: 属性选择项的类
 * @Author: iamsmiling
 * @Date: 2020-09-28 09:14:34
 * @LastEditTime: 2020-09-28 09:19:29
 */

import 'package:taojuwu/utils/common_kit.dart';

class GoodsAttrBean {
  int id;
  String name;
  String picture;
  double price;
  bool isChecked;
  GoodsAttrBean.fromJson(Map<String, dynamic> json) {
    id = json['id'].runtimeType == int ? json['id'] : int.parse(json['id']);
    name = json['name'] ?? '';
    picture = json['picture'] ?? '';
    price = CommonKit.parseDouble(json['price']);
    isChecked = json['is_checked'];
  }
}
