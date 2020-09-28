/*
 * @Description: 空间属性
 * @Author: iamsmiling
 * @Date: 2020-09-25 12:47:45
 * @LastEditTime: 2020-09-27 18:08:39
 */
import 'package:taojuwu/repository/zy_response.dart';
import 'package:taojuwu/utils/common_kit.dart';

class RoomAttr extends ZYResponse<List<RoomAttrBean>> {
  RoomAttr.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    List _data = json['data'] is List ? json['data'] : [];
    this.data = this.valid
        ? _data.map((item) => RoomAttrBean.fromJson(item)).toList()
        : null;
  }
}

class RoomAttrBean {
  int id;
  String name;
  String picture;
  double price;
  bool isChecked;
  RoomAttrBean(
      {this.id, this.name, this.price, this.picture, this.isChecked = false});

  RoomAttrBean.fromJson(Map<String, dynamic> json) {
    id = json['id'].runtimeType == int ? json['id'] : int.parse(json['id']);
    name = json['name'] ?? '';
    picture = json['picture'] ?? '';
    price = CommonKit.parseDouble(json['price']);
    isChecked = json['is_checked'];
  }
}
