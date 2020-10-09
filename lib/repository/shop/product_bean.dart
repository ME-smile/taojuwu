import 'package:taojuwu/repository/zy_response.dart';
import 'package:taojuwu/utils/common_kit.dart';

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
  List<RelatedGoodsBean> relatedGoodsList;
  List<SoftProjectBean> softProjectList;
  static ProductBeanDataWrapper fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ProductBeanDataWrapper dataBean = ProductBeanDataWrapper();
    dataBean.goodsId = map['goods_id'];
    dataBean.skuId =
        map['sku_id'] is String ? int.parse(map['sku_id']) : map['sku_id'];
    dataBean.goodsDetail = ProductBean.fromMap(map['goods_detail']);
    dataBean?.relatedGoodsList = CommonKit.parseList(map['related_goods'])
        .map((o) => RelatedGoodsBean.fromJson(o))
        ?.toList();
    dataBean.softProjectList = CommonKit.parseList(map['soft_project_list'])
        ?.map((e) => SoftProjectBean.fromJson(e))
        ?.toList();
    return dataBean;
  }
}

class ProductBean {
  int goodsId;
  String goodsName;
  int measureId;
  int shopId;
  int isCollect;
  int goodsType;
  double marketPrice;
  double price;
  int picture;
  int goodsSpecialType;
  String description;
  int isStockVisible;
  int isHot;
  List<ProductBeanSpecListBean> specList;
  List<SkuBean> skuList;
  List<ProductBeanGoodsImageBean> goodsImgList;
  String skuName;
  int skuId;
  String picCoverMicro;
  String categoryName;
  int count = 1;

  bool get isEndProduct => goodsType == 0; // 判断是否为成品类型
  bool get isPromotionGoods => marketPrice != 0 && marketPrice != price;
  bool get hasLiked => isCollect == 1;

  String get unit => goodsSpecialType == 2 ? '元/平方米' : '元/米';
  int fixHeight;
  String get picCoverBig {
    return goodsImgList?.isEmpty == true
        ? ''
        : goodsImgList?.first?.picCoverBig;
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
    tmpBean.isCollect = map['is_collect'];
    tmpBean.goodsType = map['goods_type'];
    tmpBean?.skuId = CommonKit.parseInt(map['sku_id']);

    tmpBean.marketPrice = CommonKit.parseDouble(map['market_price']);

    tmpBean.price = CommonKit.parseDouble(map['price']);

    tmpBean.picture = map['picture'];

    tmpBean.description = map['description'];

    tmpBean.isStockVisible = map['is_stock_visible'];
    tmpBean.isHot = map['is_hot'];
    tmpBean.goodsSpecialType = map['goods_special_type'];

    tmpBean.specList = List()
      ..addAll((map['spec_list'] as List ?? [])
          .map((o) => ProductBeanSpecListBean.fromMap(o)));
    tmpBean.skuList = List()
      ..addAll((map['sku_list'] as List ?? []).map((o) => SkuBean.fromJson(o)));
    tmpBean.goodsImgList = List()
      ..addAll((map['goods_img_list'] as List ?? [])
          .map((o) => ProductBeanGoodsImageBean.fromMap(o)));

    tmpBean.skuName = map['sku_name'];

    tmpBean?.picCoverMicro = map['pic_cover_micro'];
    tmpBean?.categoryName = map['category_name'];
    tmpBean?.fixHeight = map['fix_height'];

    return tmpBean;
  }
}

class ProductBeanGoodsImageBean {
  String picCoverBig;
  String picSizeBig;
  String picSpecBig;
  String picCoverMid;
  String picSizeMid;
  String picSpecMid;

  String bucket;

  static ProductBeanGoodsImageBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ProductBeanGoodsImageBean tempBean = ProductBeanGoodsImageBean();

    tempBean.picCoverBig = map['pic_cover_big'];
    tempBean.picSizeBig = map['pic_size_big'];
    tempBean.picSpecBig = map['pic_spec_big'];
    tempBean.picCoverMid = map['pic_cover_mid'];
    tempBean.picSizeMid = map['pic_size_mid'];
    tempBean.picSpecMid = map['pic_spec_mid'];

    tempBean.bucket = map['bucket'];
    return tempBean;
  }
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
}

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
}

class RelatedGoodsBean {
  int goodsId;
  String goodsName;
  int goodsType;
  double price;
  double marketPrice;
  String picture;
  String unit;

  bool get isOnSale => price < marketPrice;

  RelatedGoodsBean.fromJson(Map<String, dynamic> json) {
    goodsId = json['goods_id'];
    goodsName = json['goods_name'];
    goodsType = json['goods_type'];
    price = CommonKit.parseDouble(json['price']);
    marketPrice = CommonKit.parseDouble(json['market_price']);
    picture = json['picture'];
    unit = json['unit'];
  }
}

class SoftProjectBean {
  int scenesId;
  String scenesName;
  String picture;
  String name;

  List<SoftProjectGoodsBean> goodsList;
  double totalPrice;

  double get marketPrice {
    double tmp = 0.0;
    if (!CommonKit.isNullOrEmpty(goodsList)) {
      goodsList?.forEach((el) {
        tmp += el.price;
      });
      return tmp;
    }
    return tmp;
  }

  SoftProjectBean.fromJson(Map<String, dynamic> json) {
    scenesId = json['scenes_id'];
    scenesName = json['scenes_name'];
    picture = json['picture'];
    name = json['name'];
    goodsList = CommonKit.parseList(json['goods_list'])
        ?.map((e) => SoftProjectGoodsBean.fromJson(e))
        ?.toList();
    totalPrice = CommonKit.parseDouble(json['total_price']);
  }
}

class SoftProjectGoodsBean {
  int goodsId;
  String goodsName;
  double marketPrice;
  double price;

  SoftProjectGoodsBean.fromJson(Map<String, dynamic> json) {
    goodsId = json['goods_id'];
    goodsName = json['goods_name'];
    marketPrice = CommonKit.parseDouble(json['market_price']);
    price = CommonKit.parseDouble(json['price']);
  }
}
