import 'package:taojuwu/models/zy_response.dart';

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
    id = json['id'].runtimeType == int ? json['id'] : int.parse(json['id']);
    name = json['name'] ?? '';
    picture = json['picture'] ?? '';
    price = json['price'].runtimeType == double
        ? json['price']
        : double.parse(json['price']);
    items = json['items'].runtimeType == int
        ? json['items']
        : int.parse(json['items']);
    isChecked = false;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'picture': picture,
        'price': price,
        'items': items
      };
}
