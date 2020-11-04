/*
 * @Description: //sku详情
 * @Author: iamsmiling
 * @Date: 2020-09-25 12:47:45
 * @LastEditTime: 2020-11-02 15:22:27
 */
import 'package:taojuwu/repository/base/count_model.dart';

class ProductSkuBean extends CountModel {
  String skuName;
  String attrValueItems;
  String attrValueItemsFormat;
  String marketPrice;
  String price;
  String promotePrice;
  String image;
  int picId;

  int skuId;
  int goodsId;
  int stock;
  // dynamic picture;
  // ProductSkuBeanImgBucket imgBucket;

  int count = 1;

  // String get bigPicUrl => imgBucket?.bigPicUrl;
  // String get midPicUrl => imgBucket?.midPicUrl;
  // String get coverUrl => imgBucket?.cover;
  // String get tinyPicUrl => imgBucket?.smallPicUrl;
  ProductSkuBean(
      {this.skuName,
      this.attrValueItems,
      this.attrValueItemsFormat,
      this.marketPrice,
      this.price,
      this.promotePrice,
      this.skuId,
      this.goodsId,
      this.stock,
      this.picId
      // this.picture,
      });

  ProductSkuBean.fromJson(Map<String, dynamic> json) {
    skuName = json['sku_name']?.trim();

    this.attrValueItems = json['attr_value_items'];
    this.attrValueItemsFormat = json['attr_value_items_format'];
    this.marketPrice = json['market_price'];
    Map<String, dynamic> map = json['sku_img_list']?.first ?? {};
    this.image = json['image'] ?? map['pic_cover_small'] ?? '';
    String str = json['price'];
    str = str == null || str?.isEmpty == true ? '0.00' : str;
    this.price = str;

    this.promotePrice = json['promote_price'];

    this.skuId = json['sku_id'];
    this.goodsId = json['goods_id'];
    this.stock = json['stock'];
    this.picId = json['pic_id'];
    // this.picture = json['picture'];

    // this.imgBucket = json['sku_img_main'] == null
    //     ? null
    //     : ProductSkuBeanImgBucket.fromJson(json['sku_img_main']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sku_name'] = this.skuName;
    data['attr_value_items'] = this.attrValueItems;
    data['attr_value_items_format'] = this.attrValueItemsFormat;
    data['market_price'] = this.marketPrice;
    data['price'] = this.price;
    data['promote_price'] = this.promotePrice;

    data['sku_id'] = this.skuId;
    data['goods_id'] = this.goodsId;
    data['stock'] = this.stock;
    // data['picture'] = this.picture;
    return data;
  }
}

class ProductSkuBeanImgBucket {
  String picName;
  String bigPicUrl;
  String midPicUrl;
  String smallPicUrl;
  String cover;
  ProductSkuBeanImgBucket.fromJson(Map<String, dynamic> json) {
    picName = json['pic_name'];
    bigPicUrl = json['pic_cover_big'];
    midPicUrl = json['pic_cover_mid'];
    smallPicUrl = json['pic_cover_small'];
    cover = json['pic_cover'];
  }
}
