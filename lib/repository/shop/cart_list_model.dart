import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:taojuwu/constants/constants.dart';
import 'package:taojuwu/repository/base/count_model.dart';
import 'package:taojuwu/repository/base/goods_attr.dart';
import 'package:taojuwu/repository/order/order_detail_model.dart';
import 'package:taojuwu/repository/order/order_model.dart';
import 'package:taojuwu/repository/zy_response.dart';

class CartCategoryResp extends ZYResponse<CartCategoryListWrapper> {
  CartCategoryResp.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    this.data = this.valid ? CartCategoryListWrapper.fromJson(json) : null;
  }
}

class CartListResp extends ZYResponse<CartListWrapper> {
  CartListResp.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    this.data = this.valid ? CartListWrapper.fromJson(json['data']) : null;
  }
}

class CartListWrapper {
  List<CartModel> data;
  String goodsLadderPreferential;
  List<CartCategory> categoryList;
  CartListWrapper.fromJson(Map<String, dynamic> json) {
    data = List()
      ..addAll(
          (json['cart_list'] as List ?? []).map((o) => CartModel.fromJson(o)));
    goodsLadderPreferential = json['goods_ladder_preferential'];
  }

  setCategoryList(List<CartCategory> list) {
    categoryList = list;
  }
}

class CartCategoryListWrapper {
  List<CartCategory> data = [];

  CartCategoryListWrapper.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null && json['data'] is List) {
      json['data']?.forEach((item) {
        data.add(CartCategory.fromJson(item));
      });
    }
  }
}

class CartCategory {
  String name;
  String id;
  int count;
  int index;

  bool get isAll => id == '0' ? true : false;
  CartCategory.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = '${json['category_id'] ?? ''}';
    count = json['num'];
  }

  CartCategory(String name, int count) {
    this.name = name;
    this.count = count;
  }
}

class CartModel extends CountModel {
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
  double price;
  int count = 1;

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
  num promotionPrice;
  String categoryId;
  String tag = '';
  Map attr;
  List<OrderProductAttrWrapper> wcAttr;
  PictureInfo pictureInfo;
  List<GoodsAttr> attrs;
  bool hasDeleted = false;
  BuildContext ctx;
  Function callback;
  String get unit => goodsType == 2 ? '元/平方米' : '元/米';
  bool get isEndProduct => goodsType == 0; //等于0时表示成品
  bool get isCustomizedProduct => goodsType != 0;
  double get totalPrice {
    price = price == null ? 0.0 : price;

    return isEndProduct
        ? price * count
        : double.parse(estimatedPrice ?? '0.00');
  }

  CartModel.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];

    clientId = json['client_id'];
    categoryId = '${json['category_id'] ?? ''}';
    buyerId = json['buyer_id'];
    shopId = json['shop_id'];
    shopName = json['shop_name'];
    goodsId = json['goods_id'];
    goodsName = json['goods_name'];
    skuId = json['sku_id'] is int ? json['sku_id'] : int.parse(json['sku_id']);
    skuName = json['sku_name'];
    String priceStr = '${json['price'] ?? '0.00'}';
    price = double.parse(priceStr);
    count = json['num'] is int ? json['num'] : int.parse(json['num']);

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

    Map map = json['wc_attr'] is Map ? json['wc_attr'] : {};

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

    attr = json['wc_attr'] is Map ? json['wc_attr'] : {};

    //可修改的 3 5 8 12 13

    List<Map> options = [];

    List<int> mutableAttrs = [3, 5, 8, 12, 13];

    List<int> keys = attr?.keys?.map((e) => int.parse(e))?.toList();
    Constants.ATTR_MAP.forEach((key, value) {
      if (keys?.contains(key) == false) {
        attr['$key'] = {
          'name': '无',
        };
      }
    });

    attr?.forEach((key, value) {
      key = int.parse(key);
      if (mutableAttrs?.contains(key) == true) {
        Map<String, dynamic> dict = {};
        String name;
        dict['type'] = key;
        if (value is Map) {
          name = value['name'] ?? '';
          dict['id'] = value is Map ? value['id'] ?? 0 : 0;
          dict['has_selected'] = value['name']?.contains('无') == false &&
              value['name']?.contains('不') == false;
        }
        if (value is List) {
          name = value?.map((e) => e['name'] ?? '')?.toList()?.join(',');
          dict['has_selected'] = true;
          dict['id'] = value?.map((e) => e['id'] ?? 0)?.toList();
        }
        dict['attr_category'] = Constants.ATTR_MAP[key];
        dict['attr_name'] = name;
        options?.add(dict);
      }
    });
    attrs = [];
    options?.forEach((element) {
      attrs.add((GoodsAttr.fromJson(element)));
    });
  }

  Map<String, dynamic> toJson() {
    List<GoodsAttr> visibleOptions = attrs
        ?.where((element) => [3, 5, 8, 12, 13]?.contains(element?.type))
        ?.toList();
    List<Map<String, dynamic>> args =
        visibleOptions?.map((e) => e?.toJson())?.toList();

    return {
      'tag': tag,
      'img': pictureInfo?.picCoverSmall,
      'price': price,
      'goods_name': goodsName,
      'sku_id': skuId,
      'attr': jsonEncode(attr),
      'count': count,
      'measure_id': measureId,
      'total_price': isCustomizedProduct
          ? estimatedPrice is double
              ? estimatedPrice
              : double.parse(estimatedPrice ?? '0.0')
          : totalPrice,
      'is_shade': isShade,
      'cart_id': cartId,
      'goods_type': goodsType,
      'goods_attrs': jsonEncode(args),
      'desc': isEndProduct ? '$goodsAttrStr\n数量x$count' : goodsAttrStr,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class CartCountResp extends ZYResponse<int> {
  CartCountResp.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    this.data = this.valid ? json['data'] : null;
  }
}

class GoodsAttrWrapper {
  List<GoodsAttr> goodsAttrList;
  double totalPrice;

  Map<String, dynamic> toJson() {
    return {};
  }

  GoodsAttrWrapper.fromJson(Map<String, dynamic> json) {
    totalPrice = json['estimated_price'] is double
        ? json['estimated_price']
        : double.parse(json['estimated_price'] ?? '0.00');
    Map attr = json['wc_attr'] is Map ? json['wc_attr'] : {};

    //可修改的 3 5 8 12 13

    List<Map> options = [];

    List<int> mutableAttrs = [3, 5, 8, 12, 13];

    List<int> keys = attr?.keys?.map((e) => int.parse(e))?.toList();
    Constants.ATTR_MAP.forEach((key, value) {
      if (keys?.contains(key) == false) {
        attr['$key'] = {
          'name': '无',
        };
      }
    });
    attr?.forEach((key, value) {
      key = int.parse(key);
      if (mutableAttrs?.contains(key) == true) {
        Map<String, dynamic> dict = {};
        String name;
        dict['type'] = key;
        if (value is Map) {
          name = value['name'] ?? '';
          dict['id'] = value is Map ? value['id'] ?? 0 : 0;
          dict['has_selected'] = value['name']?.contains('无') == false &&
              value['name']?.contains('不') == false;
        }
        if (value is List) {
          name = value?.map((e) => e['name'] ?? '')?.toList()?.join(',');
          dict['has_selected'] = true;
          dict['id'] = value?.map((e) => e['id'] ?? 0)?.toList();
        }
        dict['attr_category'] = Constants.ATTR_MAP[key];
        dict['attr_name'] = name;
        options?.add(dict);
      }
    });
    goodsAttrList = [];
    options?.forEach((element) {
      goodsAttrList.add((GoodsAttr.fromJson(element)));
    });
  }
}
