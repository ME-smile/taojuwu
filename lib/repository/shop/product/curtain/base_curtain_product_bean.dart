/*
 * @Description: 所有窗帘类的基类
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:11:06
 * @LastEditTime: 2020-10-31 13:05:14
 */

import 'package:flutter/material.dart';
import 'package:taojuwu/application.dart';
import 'package:taojuwu/event_bus/events/add_to_cart_event.dart';
import 'package:taojuwu/repository/order/order_detail_model.dart';
import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';
import 'package:taojuwu/repository/zy_response.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/toast_kit.dart';

import 'abstract_curtain_product_bean.dart';
import 'package:taojuwu/utils/extensions/object_kit.dart';

import 'style_selector/curtain_style_selector.dart';

abstract class BaseCurtainProductBean extends AbstractCurtainProductBean {
  List<ProductSkuAttr> attrList = []; // 窗纱 工艺方式 型材 里布 幔头 配饰等属性
  ProductSkuAttr roomAttr;
  OrderGoodsMeasureData measureData = OrderGoodsMeasureData();
  CurtainStyleSelector styleSelector =
      CurtainStyleSelector(); // 样式选择  只有布艺帘才需要选择 这些属性
  double get widthCM => measureData?.widthCM; //宽度
  double get heightCM => measureData?.heightCM; // 高度
  double get deltaYCM => measureData?.deltaYCM; // 离地距离

  num get widthM =>
      measureData?.hasSetSize == true ? measureData?.widthM : width ?? 0.0;
  num get heightM =>
      measureData?.hasSetSize == true ? measureData?.heightM : height ?? 0.0;

  String get widthMStr => measureData?.widthMStr;
  String get heightMStr => measureData?.heightMStr;
  //是否为测量单选品
  bool get isMeasureOrder => measureData?.orderGoodsId != null;
  BaseCurtainProductBean.fromJson(Map<String, dynamic> json)
      : super.fromJson(json); //空间属性

  Map<dynamic, dynamic> get attrArgs {
    Map<dynamic, dynamic> params = {};
    params.addAll({
      '1': {
        'name': roomAttr?.selectedAttrName,
        'id': roomAttr?.selcetedAttrBean?.id
      }
    });
    for (ProductSkuAttr attr in attrList) {
      params.addAll(attr?.toJson());
    }
    params.addAll({
      '9': [
        {
          'name': '宽',
          'value': widthCM,
        },
        {'name': '高', 'value': heightCM}
      ]
    });

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

  // 校验宽度
  bool _isValidWidth() {
    if (widthCM == null) {
      ToastKit.showInfo('请填写宽度');
      return false;
    }
    if (widthCM == 0) {
      ToastKit.showInfo('宽度不能为0哦');
      return false;
    }
    if (widthCM > 100 * 100) {
      ToastKit.showInfo('宽度不能超过100米');
      return false;
    }
    return true;
  }

  // 校验高度
  bool _isValidHeight() {
    if (heightCM == null) {
      ToastKit.showInfo('请填写高度');
      return false;
    }
    if (heightCM == 0) {
      ToastKit.showInfo('高度不能为0哦');
      return false;
    }
    if (heightCM > 350) {
      ToastKit.showInfo('暂不支持3.5m以上定制');
      return false;
    }
    return true;
  }

  bool get isValidSize => _isValidWidth() && _isValidHeight();

  Future addToCartRequest() {
    print(cartArgs);
    print('__________++++++++++');
    return OTPService.addCart(params: cartArgs).then((ZYResponse response) {
      if (response?.valid == true) {
        ToastKit.showSuccessDIYInfo('加入购物车成功');
        Application.eventBus.fire(AddToCartEvent(response?.data));
      } else {
        ToastKit.showErrorInfo(response?.message);
      }
    }).catchError((err) => err);
  }

  // 测装数据参数
  Map<String, dynamic> get mesaureDataArg {
    return {
      'width': widthCM,
      'height': heightCM,
      'vertical_ground_height': deltaYCM,
      'goods_id': goodsId,
      'install_room': roomAttr?.selcetedAttrBean?.id,
    };
  }

  //保存侧窗数据接口
  Future saveMeasure(BuildContext context) {
    return OTPService.saveMeasure(context, params: mesaureDataArg)
        .then((ZYResponse response) {
      if (response?.valid == true) {
        measureData?.id = int.parse(response?.data);
      }
    }).catchError((err) {
      return false;
    });
  }

  @override
  int get skuId => skuList?.first?.skuId ?? 0;
}
