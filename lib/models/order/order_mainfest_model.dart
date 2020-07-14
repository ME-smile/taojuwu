import '../zy_response.dart';

class OrderMainfestModelResp extends ZYResponse<OrderMainfestModel> {
  OrderMainfestModelResp.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    this.data = this.valid ? OrderMainfestModel.fromJson(json['data']) : null;
  }
}

class OrderMainfestModel {
  String clientName;
  String orderNo;
  List<GoodsMainfest> checkList;

  OrderMainfestModel.fromJson(Map<String, dynamic> json) {
    clientName = json['client_name'];
    orderNo = json['order_no'];
    if (json['goods_list'] != null) {
      checkList = new List<GoodsMainfest>();
      json['goods_list'].forEach((v) {
        checkList.add(new GoodsMainfest.fromJson(v));
      });
    }
  }
}

class GoodsMainfest {
  int count;
  String price;
  String statusName;
  List<GoodsMainfestAttr> list;

  GoodsMainfest.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = new List<GoodsMainfestAttr>();
      json['list'].forEach((v) {
        list.add(new GoodsMainfestAttr.fromJson(v));
      });
    }
    statusName = json['status_name'];
    count = json['count'];
    price = json['price'];
  }
}

class GoodsMainfestAttr {
  String goodsName;
  String material;
  String price;
  String goodsPrice;

  GoodsMainfestAttr.fromJson(Map<String, dynamic> json) {
    goodsName = json['goods_name'];
    material = json['material'] == null || json['material'].isEmpty
        ? '0.00'
        : json['material'];
    price =
        json['price'] == null || json['price'].isEmpty ? '0.00' : json['price'];
    goodsPrice = json['goods_price'] == null || json['goods_price'].isEmpty
        ? '0.00'
        : json['goods_price'];
  }
}
