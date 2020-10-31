import 'package:taojuwu/repository/shop/product/abstract/base_product_bean.dart';
import 'package:taojuwu/repository/shop/product/abstract/single_product_bean.dart';
import 'package:taojuwu/repository/shop/product/curtain/fabric_curtain_product_bean.dart';
import 'package:taojuwu/repository/shop/product/curtain/rolling_curtain_product_bean.dart';
import 'package:taojuwu/repository/shop/product/design/scene_design_product_bean.dart';
import 'package:taojuwu/repository/shop/product/design/soft_design_product_bean.dart';
import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';
import 'package:taojuwu/repository/zy_response.dart';
import 'package:taojuwu/utils/common_kit.dart';

import 'curtain_product_list_model.dart';
import 'product/end_product/concrete_end_product_bean.dart';
import 'product/relative_product/relative_product_bean.dart';
import 'product_sku_bean.dart';
import 'sku_attr/window_style_sku_option.dart';

class ProductBeanRespList extends ZYResponse<ListDataWrapperProductBean> {
  ProductBeanRespList.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    this.data =
        !this.valid ? null : ListDataWrapperProductBean.fromJson(json['data']);
  }
}

class LikedProductList extends ZYResponse<List<ProductBean>> {
  LikedProductList.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    this.data = this.valid && json['data'] != null
        ? List.of(json['data']).map((v) => ProductBean.fromJson(v)).toList()
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
        List.of(json['data']).map((v) => ProductBean.fromJson(v)).toList();
    this.totalCount = json['total_count'];
    this.pageCount = json['page_count'];
  }
}

class ProductBeanResp extends ZYResponse<ProductBeanDataWrapper> {
  ProductBeanResp.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    this.data =
        !this.valid ? null : ProductBeanDataWrapper.fromJson(json['data']);
  }
}

class ProductBeanDataWrapper {
  String goodsId;
  int skuId;
  SingleProductBean goodsDetail;
  List<RelativeProductBean> relativeProductList = [];
  List<SceneDesignProductBean> sceneDesignProductList = [];
  List<SoftDesignProductBean> softDesignProductList = [];
  List<BaseProductBean> recommendProductList = [];

  ProductBeanDataWrapper.fromJson(Map<String, dynamic> map) {
    goodsId = map['goods_id'];
    skuId = CommonKit.parseInt(map['sku_id']);
    Map<String, dynamic> json = map['goods_detail'];
    int type = json['goods_type'];
    if (type == 0) {
      goodsDetail = ConcreteEndProductBean.fromJson(json);
    }
    if (type == 1) {
      goodsDetail = FabricCurtainProductBean.fromJson(json);
    }
    if (type == 2) {
      goodsDetail = RollingCurtainProductBean.fromJson(json);
    }
    // goodsDetail = FabricCurtainProductBean.fromJson(map['goods_detail']);
    relativeProductList = CommonKit.parseList(map['related_goods'])
        .map((o) => RelativeProductBean.fromJson(o))
        ?.toList();
    sceneDesignProductList = CommonKit.parseList(map['scenes_list'])
        ?.map((e) => SceneDesignProductBean.fromJson(e))
        ?.toList();
    softDesignProductList = CommonKit.parseList(map['soft_project_list'])
        ?.map((e) => SoftDesignProductBean.fromJson(e))
        ?.toList();
    recommendProductList =
        CommonKit.parseList(map['referrals_goods'])?.map((e) {
      int type = e == null ? null : e['goods_type'];
      return type == 0
          ? ConcreteEndProductBean.fromJson(e)
          : type == 1
              ? FabricCurtainProductBean.fromJson(e)
              : RollingCurtainProductBean.fromJson(e);
    })?.toList();
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
  dynamic picture;
  int goodsSpecialType;
  String description;
  int isStockVisible;
  int isHot;
  List<ProductBeanSpecListBean> specList;
  List<ProductSkuBean> skuList;
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

  ProductBean.fromJson(Map<String, dynamic> map) {
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
          .map((o) => ProductBeanSpecListBean.fromMap(o)));
    skuList = List()
      ..addAll((map['sku_list'] as List ?? [])
          .map((o) => ProductSkuBean.fromJson(o)));
    goodsImgList = List()
      ..addAll((map['goods_img_list'] as List ?? [])
          .map((o) => ProductBeanGoodsImageBean.fromMap(o)));

    skuName = map['sku_name'];

    picCoverMicro = map['pic_cover_micro'];
    categoryName = map['category_name'];
    fixHeight = map['fix_height'];
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
