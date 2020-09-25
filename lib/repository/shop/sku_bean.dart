import 'package:taojuwu/repository/base/count_model.dart';

class SkuBean extends CountModel {
  String skuName;
  String attrValueItems;
  String attrValueItemsFormat;
  String marketPrice;
  String price;
  String promotePrice;
  String costPrice;
  String fxPrice;
  String ypFee;
  String code;
  String qRcode;
  String weight;
  String volume;
  String skuImgArray;
  String extendJson;
  int skuId;
  int goodsId;
  int stock;
  int picture;
  int createDate;
  int updateDate;
  int fxGet;
  SkuBeanImgBucket imgBucket;

  int count = 1;

  String get bigPicUrl => imgBucket?.bigPicUrl;
  String get midPicUrl => imgBucket?.midPicUrl;
  String get coverUrl => imgBucket?.cover;
  String get tinyPicUrl => imgBucket?.smallPicUrl;
  SkuBean(
      {this.skuName,
      this.attrValueItems,
      this.attrValueItemsFormat,
      this.marketPrice,
      this.price,
      this.promotePrice,
      this.costPrice,
      this.fxPrice,
      this.ypFee,
      this.code,
      this.qRcode,
      this.weight,
      this.volume,
      this.skuImgArray,
      this.extendJson,
      this.skuId,
      this.goodsId,
      this.stock,
      this.picture,
      this.createDate,
      this.updateDate,
      this.fxGet});

  SkuBean.fromJson(Map<String, dynamic> json) {
    this.skuName = json['sku_name'];
    this.attrValueItems = json['attr_value_items'];
    this.attrValueItemsFormat = json['attr_value_items_format'];
    this.marketPrice = json['market_price'];
    String str = json['price'];
    str = str == null || str?.isEmpty == true ? '0.00' : str;
    this.price = str;

    this.promotePrice = json['promote_price'];
    this.costPrice = json['cost_price'];
    this.fxPrice = json['fx_price'];
    this.ypFee = json['yp_fee'];
    this.code = json['code'];
    this.qRcode = json['QRcode'];
    this.weight = json['weight'];
    this.volume = json['volume'];
    this.skuImgArray = json['sku_img_array'];
    this.extendJson = json['extend_json'];
    this.skuId = json['sku_id'];
    this.goodsId = json['goods_id'];
    this.stock = json['stock'];
    this.picture = json['picture'];
    this.createDate = json['create_date'];
    this.updateDate = json['update_date'];
    this.fxGet = json['fx_get'];
    this.imgBucket = json['sku_img_main'] == null
        ? null
        : SkuBeanImgBucket.fromJson(json['sku_img_main']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sku_name'] = this.skuName;
    data['attr_value_items'] = this.attrValueItems;
    data['attr_value_items_format'] = this.attrValueItemsFormat;
    data['market_price'] = this.marketPrice;
    data['price'] = this.price;
    data['promote_price'] = this.promotePrice;
    data['cost_price'] = this.costPrice;
    data['fx_price'] = this.fxPrice;
    data['yp_fee'] = this.ypFee;
    data['code'] = this.code;
    data['QRcode'] = this.qRcode;
    data['weight'] = this.weight;
    data['volume'] = this.volume;
    data['sku_img_array'] = this.skuImgArray;
    data['extend_json'] = this.extendJson;
    data['sku_id'] = this.skuId;
    data['goods_id'] = this.goodsId;
    data['stock'] = this.stock;
    data['picture'] = this.picture;
    data['create_date'] = this.createDate;
    data['update_date'] = this.updateDate;
    data['fx_get'] = this.fxGet;
    return data;
  }
}

class SkuBeanImgBucket {
  String picName;
  String bigPicUrl;
  String midPicUrl;
  String smallPicUrl;
  String cover;
  SkuBeanImgBucket.fromJson(Map<String, dynamic> json) {
    picName = json['pic_name'];
    bigPicUrl = json['pic_cover_big'];
    midPicUrl = json['pic_cover_mid'];
    smallPicUrl = json['pic_cover_small'];
    cover = json['pic_cover'];
  }
}
