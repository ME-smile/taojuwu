import 'package:taojuwu/models/zy_response.dart';

class WindowStyleOptionResp extends ZYResponse<WindowStyleOption> {
  WindowStyleOptionResp.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    this.data = this.valid ? WindowStyleOption.fromJson(json['data']) : null;
  }
}

class WindowStyleOption {
  int id;
  String name;
  String picture;
  String price;
  List<WindowStyleOptionItemWrapper> items;

  WindowStyleOption({this.id, this.name, this.picture, this.price, this.items});

  WindowStyleOption.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    picture = json['picture'];
    price = json['price'];
    if (json['items'] != null) {
      items = new List<WindowStyleOptionItemWrapper>();
      json['items'].forEach((v) {
        items.add(new WindowStyleOptionItemWrapper.fromJson(v));
      });
    }
  }
}

class WindowStyleOptionItemWrapper {
  String name;
  String type;
  List<WindowStyleOptionItem> items;

  WindowStyleOptionItemWrapper.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    if (json['items'] != null) {
      items = new List<WindowStyleOptionItem>();
      json['items'].forEach((v) {
        items.add(WindowStyleOptionItem.fromJson(v));
      });
    }
  }
}

class WindowStyleOptionItem {
  String name;

  WindowStyleOptionItem({this.name});

  WindowStyleOptionItem.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }
}
