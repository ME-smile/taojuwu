/*
 * @Description: 配饰属性
 * @Author: iamsmiling
 * @Date: 2020-09-25 12:47:45
 * @LastEditTime: 2020-09-27 17:57:16
 */
import 'package:taojuwu/repository/zy_response.dart';
import 'package:taojuwu/utils/common_kit.dart';

class AccessoryAttr extends ZYResponse<List<AccessoryAttrBean>> {
  AccessoryAttr.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    List _data = json['data'] is List ? json['data'] : [];
    
    this.data = this.valid
        ? _data.map((item) => AccessoryAttrBean.fromJson(item)).toList()
        : null;
  }
}

class AccessoryAttrBean {
  int id;
  String name;
  String picture;
  double price;
  int items;
  bool isChecked;
  AccessoryAttrBean(
      {this.id, this.name, this.price, this.picture, this.isChecked: false});

  AccessoryAttrBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? '';
    picture = json['picture'] ?? '';
    price = CommonKit.parseDouble(json['price']);
    items = CommonKit.parseInt(json['items']);
    isChecked = false;
  }
}
