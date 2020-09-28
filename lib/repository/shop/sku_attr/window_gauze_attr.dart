/*
 * @Description: 窗纱属性
 * @Author: iamsmiling
 * @Date: 2020-09-25 12:47:45
 * @LastEditTime: 2020-09-27 17:59:59
 */
import 'package:taojuwu/repository/zy_response.dart';
import 'package:taojuwu/utils/common_kit.dart';

class WindowGauzeAttr extends ZYResponse<List<WindowGauzeAttrBean>> {
  WindowGauzeAttr.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    List _data = json['data'] is List ? json['data'] : [];
    for (int i = 0; i < _data.length; i++) {
      _data[i]['is_checked'] = i == 0;
    }
    this.data = this.valid
        ? _data.map((item) => WindowGauzeAttrBean.fromJson(item)).toList()
        : null;
  }
}

class WindowGauzeAttrBean {
  int id;
  String name;
  String picture;
  double price;
  bool isChecked;
  WindowGauzeAttrBean(
      {this.id, this.name, this.price, this.picture, this.isChecked = false});

  WindowGauzeAttrBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? '';
    picture = json['picture'] ?? '';
    price = CommonKit.parseDouble(json['price']);
    isChecked = json['is_checked'];
  }
}
