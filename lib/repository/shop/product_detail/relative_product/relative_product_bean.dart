/*
 * @Description: 相关商品 数据模型  同料商品
 * @Author: iamsmiling
 * @Date: 2020-10-22 16:28:55
 * @LastEditTime: 2020-11-05 10:15:18
 */
import 'package:flutter/cupertino.dart';
import 'package:taojuwu/repository/shop/product_detail/abstract/abstract_base_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/abstract/base_product_detail_bean.dart';
import 'package:taojuwu/utils/common_kit.dart';

import '../../product_sku_bean.dart';
import 'package:taojuwu/utils/extensions/map_kit.dart';

class RelativeProductDetailBean extends BaseProductDetailBean {
  int goodsId;
  String goodsName;
  int shopId;
  int isCollect;
  //0  成品  1 布艺帘  2卷帘
  int goodsType;
  double marketPrice;
  double price;
  String description;
  List<ProductSkuBean> skuList;
  List<String> goodsImgList;
  String skuName;

  String picture;
  num width;
  num height;
  int picId;
  int count = 1;
  String cover;
  List<String> detailImgList;

  String unit;

  bool get isPromotionalProduct => marketPrice != 0 && price < marketPrice;
  //是否为成品
  bool get isEndProduct => goodsType == 0;
  // 是否为布艺帘
  bool get isFabricCurtainProduct => goodsType == 1;
  // 是否为卷帘
  bool get isRollingCurtainProduct => goodsType == 2;
  RelativeProductDetailBean.fromJson(Map<String, dynamic> json) {
    goodsId = json['goods_id'];
    goodsName = json['goods_name'];
    unit = json["goods_unit"];
    shopId = json['shop_id'];
    isCollect = json['is_collect'];
    goodsType = json['goods_type'];
    picId = json['pic_id'];
    marketPrice = CommonKit.parseDouble(json['market_price']);
    price = CommonKit.parseDouble(json['price']);
    description = json['description'];
    skuList = CommonKit.parseList(json['sku_list'])
        .map((e) => ProductSkuBean.fromJson(e))
        ?.toList();
    goodsImgList = CommonKit.parseList(json['goods_img_list'])
        ?.map((e) => (e as Map).getValueByKey('pic_cover_big')?.toString())
        ?.toList();
    cover = CommonKit.isNullOrEmpty(goodsImgList)
        ? json['image']
        : goodsImgList?.first;

    width = json['width'];
    height = json['height'];
    skuName = json['sku_name'];
    picture = '${json['picture']}';
    detailImgList = CommonKit.parseList(json['new_description'])
        ?.map((e) => e?.toString())
        ?.toList();
  }

  @override
  double get totalPrice => 0.0;

  @override
  Future addToCart(BuildContext context, {Function callback}) {
    throw UnimplementedError();
  }

  @override
  Future buy(BuildContext context, {Function callback}) {
    return Future.value(false);
  }

  @override
  Map get attrArgs => throw UnimplementedError();

  @override
  Map<String, dynamic> get cartArgs => throw UnimplementedError();

  @override
  ProductType get productType => throw UnimplementedError();
}
