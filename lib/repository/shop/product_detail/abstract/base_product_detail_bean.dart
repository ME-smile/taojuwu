/*
 * @Description: 所有类抽象类
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:05:09
 * @LastEditTime: 2020-11-05 10:15:49
 */

import 'abstract_prodcut_detail_bean.dart';

abstract class BaseProductDetailBean extends AbstractProductDetailBean {
  // BaseProductDetailBean.fromJson(Map<String, dynamic> json) {
  //   goodsId = json['goods_id'];
  //   goodsName = json['goods_name'];
  //   shopId = json['shop_id'];
  //   isCollect = json['is_collect'];
  //   goodsType = json['goods_type'];
  //   picId = json['pic_id'];
  //   marketPrice = CommonKit.parseDouble(json['market_price']);
  //   price = CommonKit.parseDouble(json['price']);
  //   description = json['description'];
  //   skuList = CommonKit.parseList(json['sku_list'])
  //       .map((e) => ProductSkuBean.fromJson(e))
  //       ?.toList();
  //   goodsImgList = CommonKit.parseList(json['goods_img_list'])
  //       ?.map((e) => (e as Map).getValueByKey('pic_cover_big')?.toString())
  //       ?.toList();
  //   cover = CommonKit.isNullOrEmpty(goodsImgList)
  //       ? json['image']
  //       : goodsImgList?.first;

  //   width = json['width'];
  //   height = json['height'];
  //   skuName = json['sku_name'];
  //   picture = '${json['picture']}';
  //   detailImgList = CommonKit.parseList(json['new_description'])
  //       ?.map((e) => e?.toString())
  //       ?.toList();
  // }
}
