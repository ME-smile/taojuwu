import 'dart:convert';

import 'package:taojuwu/constants/constants.dart';
import 'package:taojuwu/models/order/order_model.dart';

class OrderCartGoods {
  String tag;
  String img;
  List<OrderProductAttrWrapper> wcAttr;
  String price;
  String goodsName;
  String goodsId;
  String measureId;
  String skuId;
  String isShade;
  String totalPrice;
  String attr;
  String count;
  String cartId;
  String dy;
  int goodsType;
  OrderCartGoods.fromJson(Map<String, dynamic> json) {
    tag = json['tag'];
    img = json['img'];
    if (json['wc_attr'] != null) {
      List list = json['wc_attr'].isEmpty ? [] : json['wc_attr'];
      wcAttr = list
          .map((item) =>
              OrderProductAttrWrapper.fromJson(Map.castFrom(jsonDecode(item))))
          .toList();
    }
    cartId = '${json['cart_id' ?? '']}';
    price = '${json['price']}';
    goodsName = json['goods_name'];
    measureId = '${json['measure_id'] ?? ''}';
    goodsId = '${json['goods_id'] ?? ''}';
    skuId = '${json['sku_id'] ?? ''}';
    isShade = '${json['is_shade'] ?? '0'}';
    totalPrice = json['total_price'] != null ? '${json['total_price']}' : '0';
    attr = json['attr'];
    count = '${json['count'] ?? 1}';
    dy = '${json['dy']}';
    goodsType = json['goods_type'] ?? 1;
  }

  String get unitPrice => goodsType == 2 ? '元/平方米' : '元/米';

  Map toJson() {
    Map tmp = {};
    wcAttr.forEach((item) {
      tmp[Constants.ATTR2NUM_MAP[item.attrName]] =
          item.attrs.map((i) => i.toJson()).toList();
    });
    return tmp;
  }
}
