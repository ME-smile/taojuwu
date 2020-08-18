import 'package:taojuwu/models/zy_response.dart';

import 'sku_bean.dart';

class ProductBeanResList extends ZYResponse<ListDataWrapperProductBean> {
  ProductBeanResList.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    this.data =
        !this.valid ? null : ListDataWrapperProductBean.fromJson(json['data']);
  }
}

class LikedProductList extends ZYResponse<List<ProductBean>> {
  LikedProductList.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    this.data = this.valid && json['data'] != null
        ? List.of(json['data']).map((v) => ProductBean.fromMap(v)).toList()
        : null;
  }
}

class ListDataWrapperProductBean {
  List<ProductBean> data = List();
  int totalCount;
  int pageCount;

  ListDataWrapperProductBean(this.data, this.totalCount, this.pageCount);

  ListDataWrapperProductBean.fromJson(Map<String, dynamic> json) {
    this.data =
        List.of(json['data']).map((v) => ProductBean.fromMap(v)).toList();
    this.totalCount = json['total_count'];
    this.pageCount = json['page_count'];
  }
}

class ProductBeanRes extends ZYResponse<ProductBeanDataWrapper> {
  ProductBeanRes.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    this.data =
        !this.valid ? null : ProductBeanDataWrapper.fromMap(json['data']);
  }
}

class ProductBeanDataWrapper {
  String goodsId;
  int skuId;
  ProductBean goodsDetail;

  static ProductBeanDataWrapper fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ProductBeanDataWrapper dataBean = ProductBeanDataWrapper();
    dataBean.goodsId = map['goods_id'];
    dataBean.skuId =
        map['sku_id'] is String ? int.parse(map['sku_id']) : map['sku_id'];
    dataBean.goodsDetail = ProductBean.fromMap(map['goods_detail']);
    return dataBean;
  }

  Map toJson() => {
        "goods_id": goodsId,
        "sku_id": skuId,
        "goods_detail": goodsDetail,
      };
}

class PromotionDetailPDBean {
  PromotionDetailComboPackageBean comboPackage;

  static PromotionDetailPDBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    PromotionDetailPDBean tmpBean = PromotionDetailPDBean();
    tmpBean.comboPackage =
        PromotionDetailComboPackageBean.fromMap(map['combo_package']);
    return tmpBean;
  }

  Map toJson() => {
        "combo_package": comboPackage,
      };
}

class PromotionDetailComboPackageBean {
  String promotionType;
  String promotionName;
  List<PromotionDetailComboDataBean> data;

  static PromotionDetailComboPackageBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    PromotionDetailComboPackageBean bean = PromotionDetailComboPackageBean();
    bean.promotionType = map['promotion_type'];
    bean.promotionName = map['promotion_name'];
    bean.data = List()
      ..addAll((map['data'] as List ?? [])
          .map((o) => PromotionDetailComboDataBean.fromMap(o)));
    return bean;
  }

  Map toJson() => {
        "promotion_type": promotionType,
        "promotion_name": promotionName,
        "data": data,
      };
}

class PromotionDetailComboDataBean {
  int id;
  String comboPackageName;
  String comboPackagePrice;
  String goodsIdArray;
  int isShelves;
  int shopId;
  int createTime;
  int updateTime;
  int originalPrice;
  int saveThePrice;
  ProductBean mainGoods;
  List<ProductBean> goodsArray;

  static PromotionDetailComboDataBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    PromotionDetailComboDataBean dataBean = PromotionDetailComboDataBean();
    dataBean.id = map['id'];
    dataBean.comboPackageName = map['combo_package_name'];
    dataBean.comboPackagePrice = map['combo_package_price'];
    dataBean.goodsIdArray = map['goods_id_array'];
    dataBean.isShelves = map['is_shelves'];
    dataBean.shopId = map['shop_id'];
    dataBean.createTime = map['create_time'];
    dataBean.updateTime = map['update_time'];
    dataBean.originalPrice = map['original_price'];
    dataBean.saveThePrice = map['save_the_price'];
    dataBean.mainGoods = ProductBean.fromMap(map['main_goods']);
    dataBean.goodsArray = List()
      ..addAll((map['goods_array'] as List ?? [])
          .map((o) => ProductBean.fromMap(o)));
    return dataBean;
  }

  Map toJson() => {
        "id": id,
        "combo_package_name": comboPackageName,
        "combo_package_price": comboPackagePrice,
        "goods_id_array": goodsIdArray,
        "is_shelves": isShelves,
        "shop_id": shopId,
        "create_time": createTime,
        "update_time": updateTime,
        "original_price": originalPrice,
        "save_the_price": saveThePrice,
        "main_goods": mainGoods,
        "goods_array": goodsArray,
      };
}

class ProductBean {
  int goodsId;
  String goodsName;
  var measureId;
  int shopId;
  int categoryId;
  int categoryId1;
  int categoryId2;
  int categoryId3;
  int brandId;
  String groupIdArray;
  int promotionType;
  int promoteId;
  int goodsType;
  double marketPrice;
  double price;
  String earnestMoney;
  String promotionPrice;
  String costPrice;
  int pointExchangeType;
  int pointExchange;
  int givePoint;
  int isMemberDiscount;
  String shippingFee;
  int shippingFeeId;
  int stock;
  int maxBuy;
  int clicks;
  int minStockAlarm;
  int sales;
  int collects;
  int star;
  int evaluates;
  int shares;
  int provinceId;
  int cityId;
  int picture;
  String keywords;
  String introduction;
  String description;
  String qRcode;
  String code;
  int isStockVisible;
  int isHot;
  int goodsSpecialType;
  int isCollect;
  int isRecommend;
  int isNew;
  int isPreSale;
  int isBill;
  int state;
  int sort;
  String imgIdArray;
  String skuImgArray;
  int matchPoint;
  int matchRatio;
  int realSales;
  int goodsAttributeId;
  String goodsSpecFormat;
  String goodsWeight;
  String goodsVolume;
  int shippingFeeType;
  dynamic extendCategoryId;
  dynamic extendCategoryId1;
  dynamic extendCategoryId2;
  dynamic extendCategoryId3;
  int supplierId;
  int saleDate;
  int createTime;
  int updateTime;
  int minBuy;
  int isVirtual;
  int productionDate;
  String shelfLife;
  String goodsVideoAddress;
  String pcCustomTemplate;
  String wapCustomTemplate;
  int maxUsePoint;
  int isOpenPresell;
  int presellTime;
  int presellDay;
  int presellDeliveryType;
  String presellPrice;
  String goodsUnit;
  int decimalReservationNumber;
  int integralGiveType;
  int type;
  int bargainId;
  int groupId;
  List<dynamic> goodsGroupList;
  List<ProductBeanSpecListBean> specList;
  List<SkuBean> skuList;
  List<ProductBeanGoodsImageBean> goodsImgList;
  List<ProductBeanParentCategoryNameBean> parentCategoryName;
  String goodsAttributeName;
  List<dynamic> goodsAttributeList;
  int integralBalance;
  int currentTime;
  List<dynamic> goodsLadderPreferentialList;
  List<dynamic> goodsCouponList;
  String mansongName;
  dynamic promotionDetail;
  ProductBeanGoodsPurchaseRestrictionBean goodsPurchaseRestriction;
  String baoyouName;
  List<ProductBeanShippingFeeNameBean> shippingFeeName;
  String skuName;
  int skuId;
  String memberPrice;
  List<ProductBeanGoodsImageBean> imgList;
  int skuPicture;
  String picCoverMicro;
  String categoryName;
  int count = 1;
  bool get isPromotionGoods => marketPrice != 0 && marketPrice != price;
  String get picCoverMid {
    return imgList?.isEmpty == true ? '' : imgList?.first?.picCover;
  }

  List<ProductBeanSpecValueBean> getSpecListByName(String name) {
    if (this.specList == null) return [];

    for (var item in this.specList) {
      if (name == item.specName) {
        return item.value;
      }
    }
    return [];
  }

  static ProductBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ProductBean tmpBean = ProductBean();
    tmpBean.goodsId = map['goods_id'];
    tmpBean.goodsName = map['goods_name'];
    tmpBean.shopId = map['shop_id'];
    tmpBean.categoryId = map['category_id'];
    tmpBean.categoryId1 = map['category_id_1'];
    tmpBean.categoryId2 = map['category_id_2'];
    tmpBean.categoryId3 = map['category_id_3'];
    tmpBean.brandId = map['brand_id'];
    tmpBean.groupIdArray = map['group_id_array'];
    tmpBean.promotionType = map['promotion_type'];
    tmpBean.promoteId = map['promote_id'];
    tmpBean.goodsType = map['goods_type'];
    tmpBean?.skuId = map['sku_id'];
    tmpBean.marketPrice = map['market_price'].runtimeType == double
        ? map['market_price']
        : double.parse(map['market_price'] ?? '0.00');

    tmpBean.price = map['price'].runtimeType == double
        ? map['price']
        : double.parse(map['price'] ?? '0.00');
    tmpBean.earnestMoney = map['earnest_money'];
    tmpBean.promotionPrice = map['promotion_price'];
    tmpBean.costPrice = map['cost_price'];
    tmpBean.pointExchangeType = map['point_exchange_type'];
    tmpBean.pointExchange = map['point_exchange'];
    tmpBean.givePoint = map['give_point'];
    tmpBean.isMemberDiscount = map['is_member_discount'];
    tmpBean.shippingFee = map['shipping_fee'];
    tmpBean.shippingFeeId = map['shipping_fee_id'];
    tmpBean.stock = map['stock'];
    tmpBean.maxBuy = map['max_buy'];
    tmpBean.clicks = map['clicks'];
    tmpBean.minStockAlarm = map['min_stock_alarm'];
    tmpBean.sales = map['sales'];
    tmpBean.collects = map['collects'];
    tmpBean.star = map['star'];
    tmpBean.evaluates = map['evaluates'];
    tmpBean.shares = map['shares'];
    tmpBean.provinceId = map['province_id'];
    tmpBean.cityId = map['city_id'];
    tmpBean.picture = map['picture'];
    tmpBean.keywords = map['keywords'];
    tmpBean.introduction = map['introduction'];
    tmpBean.description = map['description'];
    tmpBean.qRcode = map['QRcode'];
    tmpBean.code = map['code'];
    tmpBean.isStockVisible = map['is_stock_visible'];
    tmpBean.isHot = map['is_hot'];
    tmpBean.goodsSpecialType = map['goods_special_type'];

    tmpBean.isCollect = map['is_collect'];

    tmpBean.isRecommend = map['is_recommend'];
    tmpBean.isNew = map['is_new'];
    tmpBean.isPreSale = map['is_pre_sale'];
    tmpBean.isBill = map['is_bill'];
    tmpBean.state = map['state'];
    tmpBean.sort = map['sort'];
    tmpBean.imgIdArray = map['img_id_array'];
    tmpBean.skuImgArray = map['sku_img_array'];
    tmpBean.matchPoint = map['match_point'];
    tmpBean.matchRatio = map['match_ratio'];
    tmpBean.realSales = map['real_sales'];
    tmpBean.goodsAttributeId = map['goods_attribute_id'];
    tmpBean.goodsSpecFormat = map['goods_spec_format'];
    tmpBean.goodsWeight = map['goods_weight'];
    tmpBean.goodsVolume = map['goods_volume'];
    tmpBean.shippingFeeType = map['shipping_fee_type'];
    tmpBean.extendCategoryId = map['extend_category_id'];
    tmpBean.extendCategoryId1 = map['extend_category_id_1'];
    tmpBean.extendCategoryId2 = map['extend_category_id_2'];
    tmpBean.extendCategoryId3 = map['extend_category_id_3'];
    tmpBean.supplierId = map['supplier_id'];
    tmpBean.saleDate = map['sale_date'];
    tmpBean.createTime = map['create_time'];
    tmpBean.updateTime = map['update_time'];
    tmpBean.minBuy = map['min_buy'];
    tmpBean.isVirtual = map['is_virtual'];
    tmpBean.productionDate = map['production_date'];
    tmpBean.shelfLife = map['shelf_life'];
    tmpBean.goodsVideoAddress = map['goods_video_address'];
    tmpBean.pcCustomTemplate = map['pc_custom_template'];
    tmpBean.wapCustomTemplate = map['wap_custom_template'];
    tmpBean.maxUsePoint = map['max_use_point'];
    tmpBean.isOpenPresell = map['is_open_presell'];
    tmpBean.presellTime = map['presell_time'];
    tmpBean.presellDay = map['presell_day'];
    tmpBean.presellDeliveryType = map['presell_delivery_type'];
    tmpBean.presellPrice = map['presell_price'];
    tmpBean.goodsUnit = map['goods_unit'];
    tmpBean.decimalReservationNumber = map['decimal_reservation_number'];
    tmpBean.integralGiveType = map['integral_give_type'];
    tmpBean.type = map['type'];
    tmpBean.bargainId = map['bargain_id'];
    tmpBean.groupId = map['group_id'];
    tmpBean.goodsGroupList = map['goods_group_list'];
    tmpBean.specList = List()
      ..addAll((map['spec_list'] as List ?? [])
          .map((o) => ProductBeanSpecListBean.fromMap(o)));
    tmpBean.skuList = List()
      ..addAll((map['sku_list'] as List ?? []).map((o) => SkuBean.fromJson(o)));
    tmpBean.goodsImgList = List()
      ..addAll((map['goods_img_list'] as List ?? [])
          .map((o) => ProductBeanGoodsImageBean.fromMap(o)));
    tmpBean.parentCategoryName = List()
      ..addAll((map['parent_category_name'] as List ?? [])
          .map((o) => ProductBeanParentCategoryNameBean.fromMap(o)));
    tmpBean.goodsAttributeName = map['goods_attribute_name'];
    tmpBean.goodsAttributeList = map['goods_attribute_list'];
    tmpBean.integralBalance = map['integral_balance'];
    tmpBean.currentTime = map['current_time'];
    tmpBean.goodsLadderPreferentialList = map['goods_ladder_preferential_list'];
    tmpBean.goodsCouponList = map['goods_coupon_list'];
    tmpBean.mansongName = map['mansong_name'];
    tmpBean.promotionDetail = map['promotion_detail'];
    tmpBean.goodsPurchaseRestriction =
        ProductBeanGoodsPurchaseRestrictionBean.fromMap(
            map['goods_purchase_restriction']);
    tmpBean.baoyouName = map['baoyou_name'];
    tmpBean.shippingFeeName = List()
      ..addAll((map['shipping_fee_name'] as List ?? [])
          .map((o) => ProductBeanShippingFeeNameBean.fromMap(o)));
    tmpBean.skuName = map['sku_name'];

    tmpBean.memberPrice = map['member_price'];
    tmpBean.imgList = List()
      ..addAll((map['img_list'] as List ?? [])
          .map((o) => ProductBeanGoodsImageBean.fromMap(o)));
    tmpBean.skuPicture = map['sku_picture'];
    tmpBean?.picCoverMicro = map['pic_cover_micro'];
    tmpBean?.categoryName = map['category_name'];
    return tmpBean;
  }

  Map toJson() => {
        "goods_id": goodsId,
        "goods_name": goodsName,
        "shop_id": shopId,
        "category_id": categoryId,
        "category_id_1": categoryId1,
        "category_id_2": categoryId2,
        "category_id_3": categoryId3,
        "brand_id": brandId,
        "group_id_array": groupIdArray,
        "promotion_type": promotionType,
        "promote_id": promoteId,
        "goods_type": goodsType,
        "market_price": marketPrice,
        "price": price,
        "earnest_money": earnestMoney,
        "promotion_price": promotionPrice,
        "cost_price": costPrice,
        "point_exchange_type": pointExchangeType,
        "point_exchange": pointExchange,
        "give_point": givePoint,
        "is_member_discount": isMemberDiscount,
        "shipping_fee": shippingFee,
        "shipping_fee_id": shippingFeeId,
        "stock": stock,
        "max_buy": maxBuy,
        "clicks": clicks,
        "min_stock_alarm": minStockAlarm,
        "sales": sales,
        "collects": collects,
        "star": star,
        "evaluates": evaluates,
        "shares": shares,
        "province_id": provinceId,
        "city_id": cityId,
        "picture": picture,
        "keywords": keywords,
        "introduction": introduction,
        "description": description,
        "QRcode": qRcode,
        "code": code,
        "is_stock_visible": isStockVisible,
        "is_hot": isHot,
        "is_collect": isCollect,
        "is_recommend": isRecommend,
        "is_new": isNew,
        "is_pre_sale": isPreSale,
        "is_bill": isBill,
        "state": state,
        "sort": sort,
        "img_id_array": imgIdArray,
        "sku_img_array": skuImgArray,
        "match_point": matchPoint,
        "match_ratio": matchRatio,
        "real_sales": realSales,
        "goods_attribute_id": goodsAttributeId,
        "goods_spec_format": goodsSpecFormat,
        "goods_weight": goodsWeight,
        "goods_volume": goodsVolume,
        "shipping_fee_type": shippingFeeType,
        "extend_category_id": extendCategoryId,
        "extend_category_id_1": extendCategoryId1,
        "extend_category_id_2": extendCategoryId2,
        "extend_category_id_3": extendCategoryId3,
        "supplier_id": supplierId,
        "sale_date": saleDate,
        "create_time": createTime,
        "update_time": updateTime,
        "min_buy": minBuy,
        "is_virtual": isVirtual,
        "production_date": productionDate,
        "shelf_life": shelfLife,
        "goods_video_address": goodsVideoAddress,
        "pc_custom_template": pcCustomTemplate,
        "wap_custom_template": wapCustomTemplate,
        "max_use_point": maxUsePoint,
        "is_open_presell": isOpenPresell,
        "presell_time": presellTime,
        "presell_day": presellDay,
        "presell_delivery_type": presellDeliveryType,
        "presell_price": presellPrice,
        "goods_unit": goodsUnit,
        "decimal_reservation_number": decimalReservationNumber,
        "integral_give_type": integralGiveType,
        "type": type,
        "bargain_id": bargainId,
        "group_id": groupId,
        "goods_group_list": goodsGroupList,
        "spec_list": specList,
        "sku_list": skuList,
        "goods_img_list": goodsImgList,
        "parent_category_name": parentCategoryName,
        "goods_attribute_name": goodsAttributeName,
        "goods_attribute_list": goodsAttributeList,
        "integral_balance": integralBalance,
        "current_time": currentTime,
        "goods_ladder_preferential_list": goodsLadderPreferentialList,
        "goods_coupon_list": goodsCouponList,
        "mansong_name": mansongName,
        "promotion_detail": promotionDetail,
        "goods_purchase_restriction": goodsPurchaseRestriction,
        "baoyou_name": baoyouName,
        "shipping_fee_name": shippingFeeName,
        "sku_name": skuName,
        "sku_id": skuId,
        "member_price": memberPrice,
        "img_list": imgList,
        "sku_picture": skuPicture,
        "goods_special_type": goodsSpecialType
      };
}

/// pic_id : 18
/// shop_id : 0
/// album_id : 30
/// is_wide : 0
/// pic_name : "2019060303043746744"
/// pic_tag : "商品主图2"
/// pic_cover : "upload/goods/2019060303043746744.jpg"
/// pic_size : "61496"
/// pic_spec : "350,200"
/// pic_cover_big : "upload/goods/2019060303043746744_BIG.jpg"
/// pic_size_big : "19025"
/// pic_spec_big : "700*700"
/// pic_cover_mid : "upload/goods/2019060303043746744_MID.jpg"
/// pic_size_mid : "17166"
/// pic_spec_mid : "360*360"
/// pic_cover_small : "upload/goods/2019060303043746744_SMALL.jpg"
/// pic_size_small : "9161"
/// pic_spec_small : "240*240"
/// pic_cover_micro : "upload/goods/2019060303043746744_THUMB.jpg"
/// pic_size_micro : "1622"
/// pic_spec_micro : "60*60"
/// upload_time : 1559545477
/// upload_type : 1
/// domain : ""
/// bucket : ""

class ProductBeanGoodsImageBean {
  int picId;
  int shopId;
  int albumId;
  int isWide;
  String picName;
  String picTag;
  String picCover;
  String picSize;
  String picSpec;
  String picCoverBig;
  String picSizeBig;
  String picSpecBig;
  String picCoverMid;
  String picSizeMid;
  String picSpecMid;
  String picCoverSmall;
  String picSizeSmall;
  String picSpecSmall;
  String picCoverMicro;
  String picSizeMicro;
  String picSpecMicro;
  int uploadTime;
  int uploadType;
  String domain;
  String bucket;

  static ProductBeanGoodsImageBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ProductBeanGoodsImageBean tempBean = ProductBeanGoodsImageBean();
    tempBean.picId = map['pic_id'];
    tempBean.shopId = map['shop_id'];
    tempBean.albumId = map['album_id'];
    tempBean.isWide = map['is_wide'];
    tempBean.picName = map['pic_name'];
    tempBean.picTag = map['pic_tag'];
    tempBean.picCover = map['pic_cover'];
    tempBean.picSize = map['pic_size'];
    tempBean.picSpec = map['pic_spec'];
    tempBean.picCoverBig = map['pic_cover_big'];
    tempBean.picSizeBig = map['pic_size_big'];
    tempBean.picSpecBig = map['pic_spec_big'];
    tempBean.picCoverMid = map['pic_cover_mid'];
    tempBean.picSizeMid = map['pic_size_mid'];
    tempBean.picSpecMid = map['pic_spec_mid'];
    tempBean.picCoverSmall = map['pic_cover_small'];
    tempBean.picSizeSmall = map['pic_size_small'];
    tempBean.picSpecSmall = map['pic_spec_small'];
    tempBean.picCoverMicro = map['pic_cover_micro'];
    tempBean.picSizeMicro = map['pic_size_micro'];
    tempBean.picSpecMicro = map['pic_spec_micro'];
    tempBean.uploadTime = map['upload_time'];
    tempBean.uploadType = map['upload_type'];
    tempBean.domain = map['domain'];
    tempBean.bucket = map['bucket'];
    return tempBean;
  }

  Map toJson() => {
        "pic_id": picId,
        "shop_id": shopId,
        "album_id": albumId,
        "is_wide": isWide,
        "pic_name": picName,
        "pic_tag": picTag,
        "pic_cover": picCover,
        "pic_size": picSize,
        "pic_spec": picSpec,
        "pic_cover_big": picCoverBig,
        "pic_size_big": picSizeBig,
        "pic_spec_big": picSpecBig,
        "pic_cover_mid": picCoverMid,
        "pic_size_mid": picSizeMid,
        "pic_spec_mid": picSpecMid,
        "pic_cover_small": picCoverSmall,
        "pic_size_small": picSizeSmall,
        "pic_spec_small": picSpecSmall,
        "pic_cover_micro": picCoverMicro,
        "pic_size_micro": picSizeMicro,
        "pic_spec_micro": picSpecMicro,
        "upload_time": uploadTime,
        "upload_type": uploadType,
        "domain": domain,
        "bucket": bucket,
      };
}

class ProductBeanShippingFeeNameBean {
  int coId;
  String companyName;
  int isDefault;
  int expressFee;

  static ProductBeanShippingFeeNameBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ProductBeanShippingFeeNameBean bean = ProductBeanShippingFeeNameBean();
    bean.coId = map['co_id'];
    bean.companyName = map['company_name'];
    bean.isDefault = map['is_default'];
    bean.expressFee = map['express_fee'];
    return bean;
  }

  Map toJson() => {
        "co_id": coId,
        "company_name": companyName,
        "is_default": isDefault,
        "express_fee": expressFee,
      };
}

class ProductBeanGoodsPurchaseRestrictionBean {
  int code;
  String message;
  int value;

  static ProductBeanGoodsPurchaseRestrictionBean fromMap(
      Map<String, dynamic> map) {
    if (map == null) return null;
    ProductBeanGoodsPurchaseRestrictionBean bean =
        ProductBeanGoodsPurchaseRestrictionBean();
    bean.code = map['code'];
    bean.message = map['message'];
    bean.value = map['value'];
    return bean;
  }

  Map toJson() => {
        "code": code,
        "message": message,
        "value": value,
      };
}

class ProductBeanSpecListBean {
  String specName;
  String specId;
  String specShowType;
  List<ProductBeanSpecValueBean> value;
  int sort;

  static ProductBeanSpecListBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ProductBeanSpecListBean bean = ProductBeanSpecListBean();
    bean.specName = map['spec_name'];
    bean.specId = map['spec_id'];
    bean.specShowType = map['spec_show_type'].toString();
    bean.value = List()
      ..addAll((map['value'] as List ?? [])
          .map((o) => ProductBeanSpecValueBean.fromMap(o)));
    bean.sort = map['sort'];
    return bean;
  }

  Map toJson() => {
        "spec_name": specName,
        "spec_id": specId,
        "spec_show_type": specShowType,
        "value": value,
        "sort": sort,
      };
}

/// spec_id : "5"
/// spec_name : "幔头"
/// spec_value_name : "BMS1001 169"
/// spec_value_id : "23"
/// spec_show_type : "1"
/// spec_value_data : ""
/// selected : true
/// disabled : false

class ProductBeanSpecValueBean {
  String specId;
  String specName;
  String specValueName;
  String specValueId;
  String specShowType;
  String specValueData;
  bool selected;
  bool disabled;

  static ProductBeanSpecValueBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ProductBeanSpecValueBean valueBean = ProductBeanSpecValueBean();
    valueBean.specId = map['spec_id'];
    valueBean.specName = map['spec_name'];
    valueBean.specValueName = map['spec_value_name'];
    valueBean.specValueId = map['spec_value_id'];
    valueBean.specShowType = map['spec_show_type'].toString();
    valueBean.specValueData = map['spec_value_data'];
    valueBean.selected = map['selected'];
    valueBean.disabled = map['disabled'];
    return valueBean;
  }

  Map toJson() => {
        "spec_id": specId,
        "spec_name": specName,
        "spec_value_name": specValueName,
        "spec_value_id": specValueId,
        "spec_show_type": specShowType,
        "spec_value_data": specValueData,
        "selected": selected,
        "disabled": disabled,
      };
}

class ProductBeanParentCategoryNameBean {
  int categoryId;
  String categoryName;
  int pid;
  int level;

  static ProductBeanParentCategoryNameBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ProductBeanParentCategoryNameBean bean =
        ProductBeanParentCategoryNameBean();
    bean.categoryId = map['category_id'];
    bean.categoryName = map['category_name'];
    bean.pid = map['pid'];
    bean.level = map['level'];
    return bean;
  }

  Map toJson() => {
        "category_id": categoryId,
        "category_name": categoryName,
        "pid": pid,
        "level": level,
      };
}
