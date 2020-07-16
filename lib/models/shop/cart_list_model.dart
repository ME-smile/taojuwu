import 'dart:convert';

import 'package:taojuwu/constants/constants.dart';
import 'package:taojuwu/models/order/order_detail_model.dart';
import 'package:taojuwu/models/order/order_model.dart';
import 'package:taojuwu/models/zy_response.dart';

class CartListResp extends ZYResponse<CartListWrapper> {
  CartListResp.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    this.data = this.valid ? CartListWrapper.fromJson(json['data']) : null;
  }
}

class CartListWrapper {
  List<CartModel> data;
  String goodsLadderPreferential;
  List<Category> categories;

  CartListWrapper.fromJson(Map<String, dynamic> json) {
    data = List()
      ..addAll(
          (json['cart_list'] as List ?? []).map((o) => CartModel.fromJson(o)));
    goodsLadderPreferential = json['goods_ladder_preferential'];
    Map dict = json['category'] != null ? json['category'] : {};
    categories = [];
    dict.forEach((key, val) {
      Map<String, dynamic> tmp = {};
      tmp['tag'] = key;
      tmp['id'] = val['id'];
      tmp['count'] = val['num'];
      categories.add(Category.fromJson(tmp));
    });
  }
}

class Category {
  String tag;
  int id;
  int count;
  Category.fromJson(Map<String, dynamic> json) {
    tag = json['tag'];
    id = json['id'];
    count = json['count'];
  }
}

class CartModel {
  bool isChecked = false;
  String goodsAttrStr;
  int cartId;
  int clientId;
  int buyerId;
  int shopId;
  String shopName;
  int goodsId;
  String goodsName;
  int skuId;
  String skuName;
  int price;
  int count;
  int goodsPicture;
  int goodsType;
  int blId;
  int isShade;
  String estimatedPrice;
  String measureId;
  int stock;
  int maxBuy;
  int minBuy;
  int pointExchangeType;
  int pointExchange;
  String earnestMoney;
  int promotionPrice;
  String tag = '';
  Map attr;
  List<OrderProductAttrWrapper> wcAttr;
  PictureInfo pictureInfo;

  String get unit => goodsType == 2 ? '元/平方米' : '元/米';
  CartModel.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    clientId = json['client_id'];
    buyerId = json['buyer_id'];
    shopId = json['shop_id'];
    shopName = json['shop_name'];
    goodsId = json['goods_id'];
    goodsName = json['goods_name'];
    skuId = json['sku_id'];
    skuName = json['sku_name'];
    price = json['price'];
    count = json['num'];
    goodsPicture = json['goods_picture'];
    blId = json['bl_id'];
    isShade = json['is_shade'];
    estimatedPrice = json['estimated_price'];
    measureId = json['measure_id'];
    stock = json['stock'];
    maxBuy = json['max_buy'];
    minBuy = json['min_buy'];
    pointExchangeType = json['point_exchange_type'];
    pointExchange = json['point_exchange'];
    earnestMoney = json['earnest_money'];
    promotionPrice = json['promotion_price'];
    goodsAttrStr = json['goods_attr_str'] ?? '';
    goodsType = json['goods_special_type'];
    Map map = json['wc_attr'] ?? {};

    List<Map<String, dynamic>> wrapper = [];
    map.forEach((key, val) {
      Map<String, dynamic> tmp = {};
      if ('$key' == '1') {
        tag = val == null ? '' : val['name'];
      }
      tmp['attr_name'] = Constants.ATTR_MAP[int.parse('$key')];
      tmp['attr'] = val is List ? val : [val];
      wrapper.add(tmp);
    });

    wcAttr =
        wrapper.map((item) => OrderProductAttrWrapper.fromJson(item)).toList();
    pictureInfo = json['picture_info'] != null
        ? new PictureInfo.fromJson(json['picture_info'])
        : null;

    attr = json['wc_attr'];
  }

  Map<String, dynamic> toJson() => {
        'tag': tag,
        'img': pictureInfo?.picCoverSmall,
        'wc_attr': wcAttr?.map((item) => jsonEncode(item))?.toList(),
        'price': price,
        'goods_name': goodsName,
        'sku_id': skuId,
        'attr': jsonEncode(attr),
        'count': count,
        'measure_id': measureId,
        'total_price': estimatedPrice is double
            ? estimatedPrice
            : double.parse(estimatedPrice ?? '0.0'),
        'is_shade': isShade,
        'cart_id': cartId,
        'goods_type': goodsType
      };

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
