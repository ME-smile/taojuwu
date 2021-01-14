import 'package:taojuwu/utils/common_kit.dart';

import '../zy_response.dart';
import 'product_bean.dart';

/// code : 0
/// message : "success"
/// data : {"attr_str":"","spec_str":"","attr_array":[],"order":"","sort":"","category_id":"","brand_id":"","brand_name":"","min_price":"","max_price":"","shipping_fee":"","stock":"","platform_proprietary":"","type":1,"province_name":"","attr_url":"","goods_list":{"data":[{"goods_id":4,"goods_name":"测试","pic_cover_mid":null,"promotion_price":"0.00","market_price":"0.00","goods_type":1,"stock":0,"pic_id":null,"max_buy":0,"state":1,"is_hot":0,"is_recommend":0,"is_new":0,"sales":0,"pic_cover_small":null,"group_id_array":"0","shipping_fee":"0.00","point_exchange_type":0,"point_exchange":0,"is_open_presell":0,"img_id_array":"","introduction":"","display_price":"￥0.00","group_name":""},{"goods_id":3,"goods_name":"褶皱抱枕","pic_cover_mid":"upload/goods/2019101405490747831_MID.jpg","promotion_price":"0.00","market_price":"50.00","goods_type":1,"stock":0,"pic_id":24,"max_buy":0,"state":1,"is_hot":0,"is_recommend":0,"is_new":0,"sales":0,"pic_cover_small":"upload/goods/2019101405490747831_SMALL.jpg","group_id_array":"0","shipping_fee":"0.00","point_exchange_type":0,"point_exchange":0,"is_open_presell":0,"img_id_array":"24,25,27,26","introduction":"","display_price":"￥0.00","img_list":[{"pic_cover_big":"upload/goods/2019101405490747831_BIG.jpg","pic_cover_mid":"upload/goods/2019101405490747831_MID.jpg","pic_cover_small":"upload/goods/2019101405490747831_SMALL.jpg"},{"pic_cover_big":"upload/goods/2019101405490787811_BIG.jpg","pic_cover_mid":"upload/goods/2019101405490787811_MID.jpg","pic_cover_small":"upload/goods/2019101405490787811_SMALL.jpg"},{"pic_cover_big":"upload/goods/2019101405490859656_BIG.jpg","pic_cover_mid":"upload/goods/2019101405490859656_MID.jpg","pic_cover_small":"upload/goods/2019101405490859656_SMALL.jpg"},{"pic_cover_big":"upload/goods/2019101405490823467_BIG.jpg","pic_cover_mid":"upload/goods/2019101405490823467_MID.jpg","pic_cover_small":"upload/goods/2019101405490823467_SMALL.jpg"}],"group_name":""},{"goods_id":2,"goods_name":"小清新抱枕","pic_cover_mid":"upload/goods/2019101405385874786_MID.png","promotion_price":"60.00","market_price":"50.00","goods_type":1,"stock":0,"pic_id":6,"max_buy":0,"state":1,"is_hot":0,"is_recommend":0,"is_new":0,"sales":0,"pic_cover_small":"upload/goods/2019101405385874786_SMALL.png","group_id_array":"0","shipping_fee":"0.00","point_exchange_type":0,"point_exchange":0,"is_open_presell":0,"img_id_array":"6,7,8,9,10","introduction":"","display_price":"￥60.00","img_list":[{"pic_cover_big":"upload/goods/2019101405385874786_BIG.png","pic_cover_mid":"upload/goods/2019101405385874786_MID.png","pic_cover_small":"upload/goods/2019101405385874786_SMALL.png"},{"pic_cover_big":"upload/goods/2019101405390441139_BIG.jpg","pic_cover_mid":"upload/goods/2019101405390441139_MID.jpg","pic_cover_small":"upload/goods/2019101405390441139_SMALL.jpg"},{"pic_cover_big":"upload/goods/2019101405390492233_BIG.jpg","pic_cover_mid":"upload/goods/2019101405390492233_MID.jpg","pic_cover_small":"upload/goods/2019101405390492233_SMALL.jpg"},{"pic_cover_big":"upload/goods/2019101405390526077_BIG.jpg","pic_cover_mid":"upload/goods/2019101405390526077_MID.jpg","pic_cover_small":"upload/goods/2019101405390526077_SMALL.jpg"},{"pic_cover_big":"upload/goods/2019101405390563120_BIG.jpg","pic_cover_mid":"upload/goods/2019101405390563120_MID.jpg","pic_cover_small":"upload/goods/2019101405390563120_SMALL.jpg"}],"group_name":""},{"goods_id":1,"goods_name":"抱枕","pic_cover_mid":"upload/goods/2019101405204986765_MID.png","promotion_price":"15.00","market_price":"20.00","goods_type":1,"stock":0,"pic_id":1,"max_buy":0,"state":1,"is_hot":0,"is_recommend":0,"is_new":0,"sales":0,"pic_cover_small":"upload/goods/2019101405204986765_SMALL.png","group_id_array":"0","shipping_fee":"0.00","point_exchange_type":0,"point_exchange":0,"is_open_presell":0,"img_id_array":"1,2,5,3,4","introduction":"","display_price":"￥15.00","img_list":[{"pic_cover_big":"upload/goods/2019101405204986765_BIG.png","pic_cover_mid":"upload/goods/2019101405204986765_MID.png","pic_cover_small":"upload/goods/2019101405204986765_SMALL.png"},{"pic_cover_big":"upload/goods/2019101405205732448_BIG.jpg","pic_cover_mid":"upload/goods/2019101405205732448_MID.jpg","pic_cover_small":"upload/goods/2019101405205732448_SMALL.jpg"},{"pic_cover_big":"upload/goods/2019101405205835448_BIG.jpg","pic_cover_mid":"upload/goods/2019101405205835448_MID.jpg","pic_cover_small":"upload/goods/2019101405205835448_SMALL.jpg"},{"pic_cover_big":"upload/goods/2019101405205769211_BIG.jpg","pic_cover_mid":"upload/goods/2019101405205769211_MID.jpg","pic_cover_small":"upload/goods/2019101405205769211_SMALL.jpg"},{"pic_cover_big":"upload/goods/2019101405205802550_BIG.jpg","pic_cover_mid":"upload/goods/2019101405205802550_MID.jpg","pic_cover_small":"upload/goods/2019101405205802550_SMALL.jpg"}],"group_name":""}],"total_count":4,"page_count":1},"spec_array":[],"current_category":{"category_id":0,"category_name":"全部分类"},"total_count":4,"page_index":1}
/// title : "商品列表"

class CurtainProductListResp extends ZYResponse<CurtainProductListDataBean> {
  CurtainProductListResp.fromMap(Map<String, dynamic> json)
      : super.fromJson(json) {
    this.data =
        this.valid ? CurtainProductListDataBean.fromMap(json['data']) : null;
  }
}

/// attr_str : ""
/// spec_str : ""
/// attr_array : []
/// order : ""
/// sort : ""
/// category_id : ""
/// brand_id : ""
/// brand_name : ""
/// min_price : ""
/// max_price : ""
/// shipping_fee : ""
/// stock : ""
/// platform_proprietary : ""
/// type : 1
/// province_name : ""
/// attr_url : ""
/// goods_list : {"data":[{"goods_id":4,"goods_name":"测试","pic_cover_mid":null,"promotion_price":"0.00","market_price":"0.00","goods_type":1,"stock":0,"pic_id":null,"max_buy":0,"state":1,"is_hot":0,"is_recommend":0,"is_new":0,"sales":0,"pic_cover_small":null,"group_id_array":"0","shipping_fee":"0.00","point_exchange_type":0,"point_exchange":0,"is_open_presell":0,"img_id_array":"","introduction":"","display_price":"￥0.00","group_name":""},{"goods_id":3,"goods_name":"褶皱抱枕","pic_cover_mid":"upload/goods/2019101405490747831_MID.jpg","promotion_price":"0.00","market_price":"50.00","goods_type":1,"stock":0,"pic_id":24,"max_buy":0,"state":1,"is_hot":0,"is_recommend":0,"is_new":0,"sales":0,"pic_cover_small":"upload/goods/2019101405490747831_SMALL.jpg","group_id_array":"0","shipping_fee":"0.00","point_exchange_type":0,"point_exchange":0,"is_open_presell":0,"img_id_array":"24,25,27,26","introduction":"","display_price":"￥0.00","img_list":[{"pic_cover_big":"upload/goods/2019101405490747831_BIG.jpg","pic_cover_mid":"upload/goods/2019101405490747831_MID.jpg","pic_cover_small":"upload/goods/2019101405490747831_SMALL.jpg"},{"pic_cover_big":"upload/goods/2019101405490787811_BIG.jpg","pic_cover_mid":"upload/goods/2019101405490787811_MID.jpg","pic_cover_small":"upload/goods/2019101405490787811_SMALL.jpg"},{"pic_cover_big":"upload/goods/2019101405490859656_BIG.jpg","pic_cover_mid":"upload/goods/2019101405490859656_MID.jpg","pic_cover_small":"upload/goods/2019101405490859656_SMALL.jpg"},{"pic_cover_big":"upload/goods/2019101405490823467_BIG.jpg","pic_cover_mid":"upload/goods/2019101405490823467_MID.jpg","pic_cover_small":"upload/goods/2019101405490823467_SMALL.jpg"}],"group_name":""},{"goods_id":2,"goods_name":"小清新抱枕","pic_cover_mid":"upload/goods/2019101405385874786_MID.png","promotion_price":"60.00","market_price":"50.00","goods_type":1,"stock":0,"pic_id":6,"max_buy":0,"state":1,"is_hot":0,"is_recommend":0,"is_new":0,"sales":0,"pic_cover_small":"upload/goods/2019101405385874786_SMALL.png","group_id_array":"0","shipping_fee":"0.00","point_exchange_type":0,"point_exchange":0,"is_open_presell":0,"img_id_array":"6,7,8,9,10","introduction":"","display_price":"￥60.00","img_list":[{"pic_cover_big":"upload/goods/2019101405385874786_BIG.png","pic_cover_mid":"upload/goods/2019101405385874786_MID.png","pic_cover_small":"upload/goods/2019101405385874786_SMALL.png"},{"pic_cover_big":"upload/goods/2019101405390441139_BIG.jpg","pic_cover_mid":"upload/goods/2019101405390441139_MID.jpg","pic_cover_small":"upload/goods/2019101405390441139_SMALL.jpg"},{"pic_cover_big":"upload/goods/2019101405390492233_BIG.jpg","pic_cover_mid":"upload/goods/2019101405390492233_MID.jpg","pic_cover_small":"upload/goods/2019101405390492233_SMALL.jpg"},{"pic_cover_big":"upload/goods/2019101405390526077_BIG.jpg","pic_cover_mid":"upload/goods/2019101405390526077_MID.jpg","pic_cover_small":"upload/goods/2019101405390526077_SMALL.jpg"},{"pic_cover_big":"upload/goods/2019101405390563120_BIG.jpg","pic_cover_mid":"upload/goods/2019101405390563120_MID.jpg","pic_cover_small":"upload/goods/2019101405390563120_SMALL.jpg"}],"group_name":""},{"goods_id":1,"goods_name":"抱枕","pic_cover_mid":"upload/goods/2019101405204986765_MID.png","promotion_price":"15.00","market_price":"20.00","goods_type":1,"stock":0,"pic_id":1,"max_buy":0,"state":1,"is_hot":0,"is_recommend":0,"is_new":0,"sales":0,"pic_cover_small":"upload/goods/2019101405204986765_SMALL.png","group_id_array":"0","shipping_fee":"0.00","point_exchange_type":0,"point_exchange":0,"is_open_presell":0,"img_id_array":"1,2,5,3,4","introduction":"","display_price":"￥15.00","img_list":[{"pic_cover_big":"upload/goods/2019101405204986765_BIG.png","pic_cover_mid":"upload/goods/2019101405204986765_MID.png","pic_cover_small":"upload/goods/2019101405204986765_SMALL.png"},{"pic_cover_big":"upload/goods/2019101405205732448_BIG.jpg","pic_cover_mid":"upload/goods/2019101405205732448_MID.jpg","pic_cover_small":"upload/goods/2019101405205732448_SMALL.jpg"},{"pic_cover_big":"upload/goods/2019101405205835448_BIG.jpg","pic_cover_mid":"upload/goods/2019101405205835448_MID.jpg","pic_cover_small":"upload/goods/2019101405205835448_SMALL.jpg"},{"pic_cover_big":"upload/goods/2019101405205769211_BIG.jpg","pic_cover_mid":"upload/goods/2019101405205769211_MID.jpg","pic_cover_small":"upload/goods/2019101405205769211_SMALL.jpg"},{"pic_cover_big":"upload/goods/2019101405205802550_BIG.jpg","pic_cover_mid":"upload/goods/2019101405205802550_MID.jpg","pic_cover_small":"upload/goods/2019101405205802550_SMALL.jpg"}],"group_name":""}],"total_count":4,"page_count":1}
/// spec_array : []
/// current_category : {"category_id":0,"category_name":"全部分类"}
/// total_count : 4
/// page_index : 1

class CurtainProductListDataBean {
  String attrStr;
  String specStr;
  String currentCategoryName;
  var attrArray;
  String order;
  String sort;
  String categoryId;
  String brandId;
  String brandName;
  String minPrice;
  String maxPrice;
  String shippingFee;
  String stock;
  String platformProprietary;
  String type;
  String provinceName;
  String attrUrl;
  int categoryType;
  CurtainGoodsListWrapper goodsList;
  List<dynamic> specArray;
  CurtainCurrentCategoryBean currentCategory;
  int totalCount;
  String pageIndex;

  static CurtainProductListDataBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    CurtainProductListDataBean dataBean = CurtainProductListDataBean();
    dataBean.attrStr = map['attr_str'];
    dataBean.specStr = map['spec_str'];
    dataBean.attrArray = map['attr_array'];
    dataBean.order = map['order'];
    dataBean.sort = map['sort'];
    dataBean.currentCategoryName = map['curr_category_name'];

    dataBean.categoryId = '${map['category_id']}';
    dataBean.brandId = map['brand_id'];
    dataBean.brandName = map['brand_name'];
    dataBean.minPrice = map['min_price'];
    dataBean.maxPrice = map['max_price'];
    dataBean.shippingFee = map['shipping_fee'];
    dataBean.stock = map['stock'];
    dataBean.platformProprietary = map['platform_proprietary'];
    dataBean.type = map['type'].toString();
    dataBean.provinceName = map['province_name'];
    dataBean.attrUrl = map['attr_url'];
    dataBean.goodsList = CurtainGoodsListWrapper.fromMap(map['goods_list']);
    dataBean.specArray = map['spec_array'];
    dataBean.currentCategory =
        CurtainCurrentCategoryBean.fromMap(map['current_category']);
    dataBean.totalCount = map['total_count'];

    dataBean.categoryType = map['category_type'] is int
        ? map['category_type']
        : int.parse(
            map['category_type']?.isEmpty == true ? '0' : map['category_type']);
    return dataBean;
  }

  Map toJson() => {
        "attr_str": attrStr,
        "spec_str": specStr,
        "attr_array": attrArray,
        "order": order,
        "sort": sort,
        "category_id": categoryId,
        "brand_id": brandId,
        "brand_name": brandName,
        "min_price": minPrice,
        "max_price": maxPrice,
        "shipping_fee": shippingFee,
        "stock": stock,
        "platform_proprietary": platformProprietary,
        "type": type,
        "province_name": provinceName,
        "attr_url": attrUrl,
        "goods_list": goodsList,
        "spec_array": specArray,
        "current_category": currentCategory,
        "total_count": totalCount,
        "page_index": pageIndex,
      };
}

/// category_id : 0
/// category_name : "全部分类"

class CurtainCurrentCategoryBean {
  int categoryId;
  String categoryName;

  static CurtainCurrentCategoryBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    CurtainCurrentCategoryBean currentCategoryBean =
        CurtainCurrentCategoryBean();
    currentCategoryBean.categoryId = map['category_id'];
    currentCategoryBean.categoryName = map['category_name'];
    return currentCategoryBean;
  }

  Map toJson() => {
        "category_id": categoryId,
        "category_name": categoryName,
      };
}

/// data : [{"goods_id":4,"goods_name":"测试","pic_cover_mid":null,"promotion_price":"0.00","market_price":"0.00","goods_type":1,"stock":0,"pic_id":null,"max_buy":0,"state":1,"is_hot":0,"is_recommend":0,"is_new":0,"sales":0,"pic_cover_small":null,"group_id_array":"0","shipping_fee":"0.00","point_exchange_type":0,"point_exchange":0,"is_open_presell":0,"img_id_array":"","introduction":"","display_price":"￥0.00","group_name":""},{"goods_id":3,"goods_name":"褶皱抱枕","pic_cover_mid":"upload/goods/2019101405490747831_MID.jpg","promotion_price":"0.00","market_price":"50.00","goods_type":1,"stock":0,"pic_id":24,"max_buy":0,"state":1,"is_hot":0,"is_recommend":0,"is_new":0,"sales":0,"pic_cover_small":"upload/goods/2019101405490747831_SMALL.jpg","group_id_array":"0","shipping_fee":"0.00","point_exchange_type":0,"point_exchange":0,"is_open_presell":0,"img_id_array":"24,25,27,26","introduction":"","display_price":"￥0.00","img_list":[{"pic_cover_big":"upload/goods/2019101405490747831_BIG.jpg","pic_cover_mid":"upload/goods/2019101405490747831_MID.jpg","pic_cover_small":"upload/goods/2019101405490747831_SMALL.jpg"},{"pic_cover_big":"upload/goods/2019101405490787811_BIG.jpg","pic_cover_mid":"upload/goods/2019101405490787811_MID.jpg","pic_cover_small":"upload/goods/2019101405490787811_SMALL.jpg"},{"pic_cover_big":"upload/goods/2019101405490859656_BIG.jpg","pic_cover_mid":"upload/goods/2019101405490859656_MID.jpg","pic_cover_small":"upload/goods/2019101405490859656_SMALL.jpg"},{"pic_cover_big":"upload/goods/2019101405490823467_BIG.jpg","pic_cover_mid":"upload/goods/2019101405490823467_MID.jpg","pic_cover_small":"upload/goods/2019101405490823467_SMALL.jpg"}],"group_name":""},{"goods_id":2,"goods_name":"小清新抱枕","pic_cover_mid":"upload/goods/2019101405385874786_MID.png","promotion_price":"60.00","market_price":"50.00","goods_type":1,"stock":0,"pic_id":6,"max_buy":0,"state":1,"is_hot":0,"is_recommend":0,"is_new":0,"sales":0,"pic_cover_small":"upload/goods/2019101405385874786_SMALL.png","group_id_array":"0","shipping_fee":"0.00","point_exchange_type":0,"point_exchange":0,"is_open_presell":0,"img_id_array":"6,7,8,9,10","introduction":"","display_price":"￥60.00","img_list":[{"pic_cover_big":"upload/goods/2019101405385874786_BIG.png","pic_cover_mid":"upload/goods/2019101405385874786_MID.png","pic_cover_small":"upload/goods/2019101405385874786_SMALL.png"},{"pic_cover_big":"upload/goods/2019101405390441139_BIG.jpg","pic_cover_mid":"upload/goods/2019101405390441139_MID.jpg","pic_cover_small":"upload/goods/2019101405390441139_SMALL.jpg"},{"pic_cover_big":"upload/goods/2019101405390492233_BIG.jpg","pic_cover_mid":"upload/goods/2019101405390492233_MID.jpg","pic_cover_small":"upload/goods/2019101405390492233_SMALL.jpg"},{"pic_cover_big":"upload/goods/2019101405390526077_BIG.jpg","pic_cover_mid":"upload/goods/2019101405390526077_MID.jpg","pic_cover_small":"upload/goods/2019101405390526077_SMALL.jpg"},{"pic_cover_big":"upload/goods/2019101405390563120_BIG.jpg","pic_cover_mid":"upload/goods/2019101405390563120_MID.jpg","pic_cover_small":"upload/goods/2019101405390563120_SMALL.jpg"}],"group_name":""},{"goods_id":1,"goods_name":"抱枕","pic_cover_mid":"upload/goods/2019101405204986765_MID.png","promotion_price":"15.00","market_price":"20.00","goods_type":1,"stock":0,"pic_id":1,"max_buy":0,"state":1,"is_hot":0,"is_recommend":0,"is_new":0,"sales":0,"pic_cover_small":"upload/goods/2019101405204986765_SMALL.png","group_id_array":"0","shipping_fee":"0.00","point_exchange_type":0,"point_exchange":0,"is_open_presell":0,"img_id_array":"1,2,5,3,4","introduction":"","display_price":"￥15.00","img_list":[{"pic_cover_big":"upload/goods/2019101405204986765_BIG.png","pic_cover_mid":"upload/goods/2019101405204986765_MID.png","pic_cover_small":"upload/goods/2019101405204986765_SMALL.png"},{"pic_cover_big":"upload/goods/2019101405205732448_BIG.jpg","pic_cover_mid":"upload/goods/2019101405205732448_MID.jpg","pic_cover_small":"upload/goods/2019101405205732448_SMALL.jpg"},{"pic_cover_big":"upload/goods/2019101405205835448_BIG.jpg","pic_cover_mid":"upload/goods/2019101405205835448_MID.jpg","pic_cover_small":"upload/goods/2019101405205835448_SMALL.jpg"},{"pic_cover_big":"upload/goods/2019101405205769211_BIG.jpg","pic_cover_mid":"upload/goods/2019101405205769211_MID.jpg","pic_cover_small":"upload/goods/2019101405205769211_SMALL.jpg"},{"pic_cover_big":"upload/goods/2019101405205802550_BIG.jpg","pic_cover_mid":"upload/goods/2019101405205802550_MID.jpg","pic_cover_small":"upload/goods/2019101405205802550_SMALL.jpg"}],"group_name":""}]
/// total_count : 4
/// page_count : 1

class CurtainGoodsListWrapper {
  List<GoodsItemBean> data;
  int totalCount;
  int pageCount;

  static CurtainGoodsListWrapper fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    CurtainGoodsListWrapper goodsListBean = CurtainGoodsListWrapper();
    goodsListBean.data = List()
      ..addAll(
          (map['data'] as List ?? []).map((o) => GoodsItemBean.fromJson(o)));
    goodsListBean.totalCount = map['total_count'];
    goodsListBean.pageCount = map['page_count'];
    return goodsListBean;
  }

  Map toJson() => {
        "data": data,
        "total_count": totalCount,
        "page_count": pageCount,
      };
}

/// goods_id : 4
/// goods_name : "测试"
/// pic_cover_mid : null
/// promotion_price : "0.00"
/// market_price : "0.00"
/// goods_type : 1
/// stock : 0
/// pic_id : null
/// max_buy : 0
/// state : 1
/// is_hot : 0
/// is_recommend : 0
/// is_new : 0
/// sales : 0
/// pic_cover_small : null
/// group_id_array : "0"
/// shipping_fee : "0.00"
/// point_exchange_type : 0
/// point_exchange : 0
/// is_open_presell : 0
/// img_id_array : ""
/// introduction : ""
/// display_price : "￥0.00"
/// group_name : ""

class GoodsItemBean extends ProductDetailBean {
  int goodsId;
  String goodsName;
  dynamic picCoverMid;
  double marketPrice;
  int goodsType;
  double displayPrice;
  int goodsSpecialType;

  String unit;

  bool get isPromotionGoods {
    return marketPrice != 0 && marketPrice != displayPrice;
  }

  bool get isProduct => goodsSpecialType == 0;

  bool get isCustomizedProduct => !isProduct;

  bool get isEndProduct => goodsType == 0;

  GoodsItemBean.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    goodsId = json['goods_id'];
    goodsName = json['goods_name'];
    picCoverMid = json['pic_cover_mid'];
    marketPrice = CommonKit.parseDouble(json['market_price']);
    goodsType = CommonKit.parseInt(json['goods_type']);
    unit = json["goods_unit"];

    displayPrice = CommonKit.parseDouble(
        json['price'] ?? json['display_price'] ?? json['market_price']);
    goodsSpecialType = json['goods_special_type'];
  }
}
