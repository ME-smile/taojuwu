/*
 * @Description: 所有类抽象类
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:05:09
 * @LastEditTime: 2020-10-21 17:03:07
 */

import 'package:taojuwu/repository/shop/product_sku_bean.dart';
import 'package:taojuwu/utils/common_kit.dart';

import 'abstract_base_product_bean.dart';

class BaseProductBean extends AbstractBaseProductBean {
  int goodsId;
  String goodsName;
  int shopId;
  int isCollect;
  int goodsType;
  double marketPrice;
  double price;
  String description;
  List<ProductSkuBean> skuList;
  String skuName;
  int skuId;
  String picCoverMicro;
  int count = 1;

  BaseProductBean.fromJson(Map<String, dynamic> json) {
    goodsId = json['goods_id'];
    goodsName = json['goods_name'];
    shopId = json['shop_id'];
    isCollect = json['is_collect'];
    goodsType = json['goods_type'];
    skuId = CommonKit.parseInt(json['sku_id']);
    marketPrice = CommonKit.parseDouble(json['market_price']);
    price = CommonKit.parseDouble(json['price']);
    description = json['description'];
    skuList = CommonKit.parseList(json['sku_list'])
        .map((e) => ProductSkuBean.fromJson(e))
        ?.toList();
    picCoverMicro = json['pic_cover_micro'];
  }
}
