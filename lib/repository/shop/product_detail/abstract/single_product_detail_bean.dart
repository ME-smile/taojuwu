/*
 * @Description: 单商品的基类
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:06:20
 * @LastEditTime: 2020-12-31 13:50:13
 */

import 'package:taojuwu/repository/shop/product_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/fabric_curtain_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/gauze_curtain_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/rolling_curtain_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/end_product/concrete_end_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/end_product/sectional_product_detail_bean.dart';
import 'package:taojuwu/utils/common_kit.dart';

import 'base_product_detail_bean.dart';
import 'package:taojuwu/utils/extensions/map_kit.dart';

abstract class SingleProductDetailBean extends BaseProductDetailBean {
  int goodsId;
  String goodsName;
  String showName;
  int shopId;
  int isCollect;

  //0  成品  1 布艺帘  2卷帘
  int goodsType;
  double marketPrice;
  double price;
  List<String> goodsImgList;
  String skuName;
  int defalutSkuId;
  String picture;
  int picId;
  int count = 1;
  String cover;
  List<String> detailImgList;
  bool isChecked = true;
  num width;
  num height;
  String get unit => goodsType == 2 ? '元/平方米' : '元/米';

  bool get isPromotionalProduct => marketPrice != 0 && price < marketPrice;
  //是否为成品
  bool get isEndProduct => goodsType == 0;
  // 是否为布艺帘
  bool get isFabricCurtainProduct => goodsType == 1;
  // 是否为卷帘
  bool get isRollingCurtainProduct => goodsType == 2;

  ProductMaterialDetailBean materialInfoDetailBean;
  SingleProductDetailBean.fromJson(Map<String, dynamic> json) {
    goodsId = json['goods_id'];
    goodsName = json['goods_name'];
    showName = json['show_name'];
    shopId = json['shop_id'];
    isCollect = json['is_collect'];
    goodsType = json['goods_type'];
    picId = json['pic_id'];
    marketPrice = CommonKit.parseDouble(json['market_price']);
    price = CommonKit.parseDouble(json['price']);

    goodsImgList = CommonKit.parseList(json['goods_img_list'])
        ?.map((e) => (e as Map).getValueByKey('pic_cover_big')?.toString())
        ?.toList();
    cover = CommonKit.isNullOrEmpty(goodsImgList)
        ? json['image']
        : goodsImgList?.first ??
            CommonKit.parseMap(json['picture_info'])
                .getValueByKey('pic_cover_big');
    Map<String, dynamic> sku = json['sku_list']?.first ?? {};

    skuName = json['sku_name'] ?? sku['sku_name'];
    defalutSkuId = sku['sku_id'];

    picture = '${json['picture'] ?? sku['pic_id']}';

    detailImgList = CommonKit.parseList(json['new_description'])
        ?.map((e) => e?.toString())
        ?.toList();
    width = CommonKit.parseDouble(json['width'], defaultVal: 0.0);
    height = CommonKit.parseDouble(json['height'], defaultVal: 0.0);

    materialInfoDetailBean = ProductMaterialDetailBean.fromJson(json);
  }

  String get detailDescription => null;
  int get skuId => defalutSkuId;
  static SingleProductDetailBean instantiate(Map<String, dynamic> json) {
    int type = json['goods_type'];

    if (type == 0) {
      return ConcreteEndProductDetailBean.fromJson(json);
    }
    if (type == 1) {
      return FabricCurtainProductDetailBean.fromJson(json);
    }
    if (type == 2) {
      return RollingCurtainProductDetailBean.fromJson(json);
    }
    if (type == 3) {
      return GauzeCurtainProductDetailBean.fromJson(json);
    }
    if (type == 4) {
      return SectionalProductDetailBean.fromJson(json);
    }

    return null;
  }
}
