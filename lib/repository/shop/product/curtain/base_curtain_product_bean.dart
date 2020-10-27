/*
 * @Description: 所有窗帘类的基类
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:11:06
 * @LastEditTime: 2020-10-27 18:04:57
 */
import 'package:taojuwu/repository/order/order_detail_model.dart';
import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';
import 'package:taojuwu/services/otp_service.dart';

import 'abstract_curtain_product_bean.dart';
import 'package:taojuwu/utils/extensions/object_kit.dart';

abstract class BaseCurtainProductBean extends AbstractCurtainProductBean {
  List<ProductSkuAttr> attrList = []; // 窗纱 工艺方式 型材 里布 幔头 配饰等属性
  ProductSkuAttr roomAttr;
  OrderGoodsMeasureData measureData = OrderGoodsMeasureData();

  double get widthCM => measureData?.widthCM; //宽度
  double get heightCM => measureData?.heightCM; // 高度
  double get deltaYCM => measureData?.deltaYCM; // 离地距离

  double get widthM =>
      measureData?.hasSetSize == true ? measureData?.widthM : width;
  double get heightM =>
      measureData?.hasSetSize == true ? measureData?.heightM : height;

  String get widthMStr => measureData?.widthMStr;
  String get heightMStr => measureData?.heightMStr;
  //是否为测量单选品
  bool get isMeasureOrder => measureData?.orderGoodsId != null;
  BaseCurtainProductBean.fromJson(Map<String, dynamic> json)
      : super.fromJson(json); //空间属性

  Map<dynamic, dynamic> get attrArgs {
    Map<dynamic, dynamic> params = {};
    params.addAll(roomAttr?.toJson());
    for (ProductSkuAttr attr in attrList) {
      params.addAll(attr?.toJson());
    }
    return params;
  }

  //窗帘面积
  double get area {
    double _area = widthM * heightM;
    return _area > 0 ? _area < 1 ? 1 : _area : 0;
  }

  bool isFixedHeight;
// 获取空间

  Future fetchRoomAttrData() {
    return OTPService.skuAttr(params: {
      'parts_type': measureData?.partsType,
      'goods_id': goodsId,
      'type': 1,
      'name': '空间',
      'title': '空间选择'
    }).then((ProductSkuAttrWrapperResp response) {
      if (response?.valid == true) {
        roomAttr = response?.data;
      }
    }).catchError((err) => err);
  }

  List<ProductSkuAttr> copyAttrs() {
    return attrList?.map((e) => ProductSkuAttr.fromJson(e?.toMap()))?.toList();
  }

  void selectAttrBean(ProductSkuAttr attr, int i) {
    List<ProductSkuAttrBean> list = attr?.data ?? [];
    if (attr.canMultiSelect) {
      ProductSkuAttrBean bean = list[i];
      bean.isChecked = !bean.isChecked;
    } else {
      for (int j = 0; j < list.length; j++) {
        ProductSkuAttrBean bean = list[j];
        bean.isChecked = i == j;
      }
    }
    attr.hasSelectedAttr = true;
  }

  OrderGoodsMeasureData copyMeasureData() {
    return OrderGoodsMeasureData(
        heightCM: heightCM, widthCM: widthCM, deltaYCM: deltaYCM);
  }

  ProductSkuAttrBean getSelectedElement(int type) {
    List<ProductSkuAttrBean> list = getSelectedElementList(type);
    if (isNullOrEmpty(list)) return null;
    return list?.firstWhere((element) => element.isChecked);
  }

  List<ProductSkuAttrBean> getSelectedElementList(int type) {
    ProductSkuAttr attr;
    List<ProductSkuAttrBean> list = [];

    for (int i = 0; i < attrList.length; i++) {
      ProductSkuAttr item = attrList[i];
      if (item?.type == type) {
        attr = item;
        list = attr?.data ?? [];
        break;
      }
    }
    return list;
  }

  //当前选中的窗帘
  ProductSkuAttrBean get curWindowGauzeAttrBean => getSelectedElement(3);

  bool get hasWindowGauze =>
      curWindowGauzeAttrBean?.name?.contains('不要窗纱') == false ?? false;
  // 当前选中的型材
  ProductSkuAttrBean get curPartAttrBean => getSelectedElement(5);
  // 当前选中的里布
  ProductSkuAttrBean get curWindowShadeAttrBean => getSelectedElement(12);

  //当前选中的幔头
  ProductSkuAttrBean get curCanopyAttrBean => getSelectedElement(8);
  // 选中的配饰
  List<ProductSkuAttrBean> get selectedAccessoryBeans =>
      getAllSelectedAccessories();

  // 当前选中的空间
  ProductSkuAttrBean get curRoomAttrBean => getSelectedElement(1);

  List<ProductSkuAttrBean> getAllSelectedAccessories() {
    List<ProductSkuAttrBean> list = getSelectedElementList(13);
    if (isNullOrEmpty(list)) return null;
    return list?.where((element) => element.isChecked)?.toList();
  }

  // 商品单价
  double get unitPrice {
    return price ?? 0.00;
  }

  // 窗纱的价格
  double get windowGauzePrice {
    // if (goods.goodsSpecialType == 1) return 0.0
    return curWindowGauzeAttrBean?.price ?? 0.0;
  }

  // 型材的价格
  double get partPrice {
    // if (goods.goodsSpecialType == 1) return 0.0;
    return curPartAttrBean?.price ?? 0.0;
  }

  // 里布的价格
  double get windowShadeClothPrice {
    return curWindowShadeAttrBean?.price ?? 0.0;
  }

  // 幔头的价格
  double get canopyPrice {
    // if (goods.goodsSpecialType == 1) return 0.0;
    return curCanopyAttrBean?.price ?? 0.0;
  }

  // 配饰的价格
  double get accessoriesPrice {
    double tmp = 0.0;
    selectedAccessoryBeans?.forEach((element) {
      tmp += element.price;
    });
    return tmp;
  }

  setSize(double widthCM, double heightCM, double deltaYCM) {
    measureData.widthCM = widthCM;
    measureData.heightCM = heightCM;
    measureData.deltaYCM = deltaYCM;
    measureData.installRoom = roomAttr.selectedAttrName;
  }
}
