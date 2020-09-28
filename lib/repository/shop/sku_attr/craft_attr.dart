/*
 * @Description: 工艺方式
 * @Author: iamsmiling
 * @Date: 2020-09-25 12:47:45
 * @LastEditTime: 2020-09-27 18:08:30
 */
import 'package:taojuwu/repository/zy_response.dart';
import 'package:taojuwu/utils/common_kit.dart';

class CraftAttr extends ZYResponse<List<CraftAttrBean>> {
  CraftAttr.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    List _data = json['data'] is List ? json['data'] : [];
    for (int i = 0; i < _data.length; i++) {
      _data[i]['is_checked'] = i == 0;
    }
    this.data = this.valid
        ? _data.map((item) => CraftAttrBean.fromJson(item)).toList()
        : null;
  }
}

class CraftAttrBean {
  int id;
  String name;
  String picture;
  double price;
  bool isChecked;
  CraftAttrBean(
      {this.id, this.name, this.price, this.picture, this.isChecked = false});

  CraftAttrBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? '';
    picture = json['picture'] ?? '';
    price = CommonKit.parseDouble(json['price']);
    isChecked = json['is_checked'];
  }
}
