import 'package:taojuwu/repository/shop/product_detail/abstract/single_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/design/scene_design_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/design/soft_design_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';
import 'package:taojuwu/repository/zy_response.dart';
import 'package:taojuwu/utils/common_kit.dart';

import 'curtain_product_list_model.dart';

import 'product_sku_bean.dart';
import 'sku_attr/window_style_sku_option.dart';

class ProductDetailBeanRespList
    extends ZYResponse<ListDataWrapperProductDetailBean> {
  ProductDetailBeanRespList.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    this.data = !this.valid
        ? null
        : ListDataWrapperProductDetailBean.fromJson(json['data']);
  }
}

class LikedProductList extends ZYResponse<List<ProductDetailBean>> {
  LikedProductList.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    this.data = this.valid && json['data'] != null
        ? List.of(json['data'])
            .map((v) => ProductDetailBean.fromJson(v))
            .toList()
        : null;
  }
}

class ListDataWrapperProductDetailBean {
  List<ProductDetailBean> data = List();
  int totalCount;
  int pageCount;

  ListDataWrapperProductDetailBean(this.data, this.totalCount, this.pageCount);

  ListDataWrapperProductDetailBean.fromJson(Map<String, dynamic> json) {
    this.data = List.of(json['data'])
        .map((v) => ProductDetailBean.fromJson(v))
        .toList();
    this.totalCount = json['total_count'];
    this.pageCount = json['page_count'];
  }
}

class ProductDetailBeanResp extends ZYResponse<ProductDetailBeanDataWrapper> {
  ProductDetailBeanResp.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    this.data = !this.valid
        ? null
        : ProductDetailBeanDataWrapper.fromJson(json['data']);
  }
}

class ProductDetailBeanDataWrapper {
  String goodsId;
  int skuId;
  SingleProductDetailBean goodsDetail;
  ProductDetailBean goods;
  List<SingleProductDetailBean> relativeProductList = [];
  List<SceneDesignProductDetailBean> sceneDesignProductList = [];
  List<SoftDesignProductDetailBean> softDesignProductList = [];
  List<SingleProductDetailBean> recommendProductList = [];

  ProductDetailBeanDataWrapper.fromJson(Map<String, dynamic> map) {
    goodsId = map['goods_id'];
    skuId = CommonKit.parseInt(map['sku_id']);
    goods = ProductDetailBean.fromJson(map['goods_detail']);
    goodsDetail = SingleProductDetailBean.instantiate(map['goods_detail']);
    // goodsDetail = FabricCurtainProductDetailBean.fromJson(map['goods_detail']);
    relativeProductList = CommonKit.parseList(map['related_goods'])
        .map((o) => SingleProductDetailBean.instantiate(o))
        ?.toList();
    sceneDesignProductList = CommonKit.parseList(map['scenes_list'])
        ?.map((e) => SceneDesignProductDetailBean.fromJson(e))
        ?.toList();
    softDesignProductList = CommonKit.parseList(map['soft_project_list'])
        ?.map((e) => SoftDesignProductDetailBean.fromJson(e))
        ?.toList();
    recommendProductList =
        CommonKit.parseList(map['referrals_goods'])?.map((e) {
      return SingleProductDetailBean.instantiate(e);
    })?.toList();
  }
}

class ProductDetailBean {
  int goodsId;
  String goodsName;
  int measureId;
  int shopId;
  int isCollect;
  int goodsType;
  double marketPrice;
  double price;
  dynamic picture;
  int goodsSpecialType;
  String description;
  int isStockVisible;
  int isHot;
  List<ProductDetailBeanSpecListBean> specList;
  List<ProductSkuBean> skuList;
  List<ProductDetailBeanGoodsImageBean> goodsImgList;
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

  List<ProductDetailBeanSpecValueBean> getSpecListByName(String name) {
    if (this.specList == null) return [];

    for (var item in this.specList) {
      if (name == item.specName) {
        return item.value;
      }
    }
    return [];
  }

  ProductDetailBean.fromJson(Map<String, dynamic> map) {
    goodsId = map['goods_id'];
    goodsName = map['goods_name'];
    shopId = map['shop_id'];
    isCollect = map['is_collect'];
    goodsType = map['goods_type'];
    skuId = CommonKit.parseInt(map['sku_id']);

    marketPrice = CommonKit.parseDouble(map['market_price']);

    price = CommonKit.parseDouble(map['price']);
    picture = map['picture'];

    description = map['description'];

    isStockVisible = map['is_stock_visible'];
    isHot = map['is_hot'];
    goodsSpecialType = map['goods_special_type'];

    specList = List()
      ..addAll((map['spec_list'] as List ?? [])
          .map((o) => ProductDetailBeanSpecListBean.fromMap(o)));
    skuList = List()
      ..addAll((map['sku_list'] as List ?? [])
          .map((o) => ProductSkuBean.fromJson(o)));
    goodsImgList = List()
      ..addAll((map['goods_img_list'] as List ?? [])
          .map((o) => ProductDetailBeanGoodsImageBean.fromMap(o)));

    skuName = map['sku_name'];

    picCoverMicro = map['pic_cover_micro'];
    categoryName = map['category_name'];
    fixHeight = map['fix_height'];
  }
}

class ProductDetailBeanGoodsImageBean {
  String picCoverBig;
  String picSizeBig;
  String picSpecBig;
  String picCoverMid;
  String picSizeMid;
  String picSpecMid;

  String bucket;

  static ProductDetailBeanGoodsImageBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ProductDetailBeanGoodsImageBean tempBean =
        ProductDetailBeanGoodsImageBean();

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

class ProductDetailBeanSpecListBean {
  String specName;
  String specId;
  String specShowType;
  List<ProductDetailBeanSpecValueBean> value;
  int sort;

  static ProductDetailBeanSpecListBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ProductDetailBeanSpecListBean bean = ProductDetailBeanSpecListBean();
    bean.specName = map['spec_name'];
    bean.specId = map['spec_id'];
    bean.specShowType = map['spec_show_type'].toString();
    bean.value = List()
      ..addAll((map['value'] as List ?? [])
          .map((o) => ProductDetailBeanSpecValueBean.fromMap(o)));
    bean.sort = map['sort'];
    return bean;
  }
}

class ProductDetailBeanSpecValueBean {
  String specId;
  String specName;
  String specValueName;
  String specValueId;
  String specShowType;
  String specValueData;
  bool selected;
  bool disabled;

  static ProductDetailBeanSpecValueBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ProductDetailBeanSpecValueBean valueBean = ProductDetailBeanSpecValueBean();
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

class RelatedGoodsBean extends GoodsItemBean {
  String unit;
  RelatedGoodsBean.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    picCoverMid = json['picture'];
    unit = json['unit'];
  }
}

class ProjectGoodsBean extends GoodsItemBean {
  dynamic picCoverMid;

  String unit;

  ProjectGoodsBean.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    picCoverMid = json['picture'];
    unit = json['unit'];
  }
}

class ProjectBean {
  int scenesId;
  String scenesName;
  String goodsDetail;
  String space;
  String style;
  String picture;
  String name;
  List<ProjectGoodsBean> goodsList;
  double totalPrice;

  double get marketPrice {
    double tmp = 0.0;
    if (!CommonKit.isNullOrEmpty(goodsList)) {
      goodsList?.forEach((el) {
        tmp += el.displayPrice;
      });
      return tmp;
    }
    return tmp;
  }

  ProjectBean.fromJson(Map<String, dynamic> json) {
    scenesId = json['scenes_id'];
    scenesName = json['scenes_name'];
    picture = json['picture'];
    name = json['name'];
    space = json['space'];
    style = json['style'];
    goodsDetail = json['scenes_detail'];
    goodsList = CommonKit.parseList(json['goods_list'])
        ?.map((e) => ProjectGoodsBean.fromJson(e))
        ?.toList();
    totalPrice = CommonKit.parseDouble(json['total_price']);
  }
}

class SoftProjectBean extends ProjectBean {
  SoftProjectBean.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}

class SoftProjectGoodsBean extends GoodsItemBean {
  dynamic picCoverMid;
  double width;
  double height;
  String unit;
  List<ProductSkuBean> skuList;
  List<ProductSkuAttr> attrList;
  ProductSkuAttr roomAttr;
  //窗帘样式列表
  WindowStyleSkuOption styleSkuOption;

  SoftProjectGoodsBean.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    picCoverMid = json['picture'];
    width = CommonKit.parseDouble(json['width']);
    height = CommonKit.parseDouble(json['height']);
    unit = json['unit'];
    skuList = CommonKit.parseList(json['sku_list'])
        ?.map((e) => ProductSkuBean.fromJson(e))
        ?.toList();
  }
}

class RecommendGoodsBean extends GoodsItemBean {
  RecommendGoodsBean.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    picCoverMid = json['picture'];
  }
}

class SceneProjectBean extends ProjectBean {
  SceneProjectBean.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}
