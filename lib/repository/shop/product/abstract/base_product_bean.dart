/*
 * @Description: 所有类抽象类
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:05:09
 * @LastEditTime: 2020-11-04 14:01:24
 */

import 'package:taojuwu/repository/shop/product_sku_bean.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/utils/extensions/map_kit.dart';
import 'abstract_base_product_bean.dart';

abstract class BaseProductBean extends AbstractBaseProductBean {
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

  String get unit => goodsType == 2 ? '元/平方米' : '元/米';

  bool get isPromotionalProduct => marketPrice != 0 && price < marketPrice;
  //是否为成品
  bool get isEndProduct => goodsType == 0;
  // 是否为布艺帘
  bool get isFabricCurtainProduct => goodsType == 1;
  // 是否为卷帘
  bool get isRollingCurtainProduct => goodsType == 2;

  BaseProductBean.fromJson(Map<String, dynamic> json) {
    goodsId = json['goods_id'];
    goodsName = json['goods_name'];
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
    // json['new_description'] = [
    //   'http://buyi.taoju5.com/upload/1.webp',
    //   'http://buyi.taoju5.com/upload/2.webp',
    //   'http://buyi.taoju5.com/upload/3.webp',
    //   'http://buyi.taoju5.com/upload/4.webp',
    //   'http://buyi.taoju5.com/upload/5.webp',
    //   'http://buyi.taoju5.com/upload/6.webp',
    //   'http://buyi.taoju5.com/upload/7.webp',
    //   'http://buyi.taoju5.com/upload/8.webp'
    //   // 'http://buyi.taoju5.com/upload/11.webp',
    // ];
    detailImgList = CommonKit.parseList(json['new_description'])
        ?.map((e) => e?.toString())
        ?.toList();
  }
}
