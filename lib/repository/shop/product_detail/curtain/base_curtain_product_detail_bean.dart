/*
 * @Description: 所有窗帘类的基类
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:11:06
 * @LastEditTime: 2020-11-26 15:11:39
 */

import 'dart:convert';
import 'dart:developer' as developer;
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/application.dart';
import 'package:taojuwu/event_bus/events/add_to_cart_event.dart';
import 'package:taojuwu/repository/order/order_detail_model.dart';
import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';
import 'package:taojuwu/repository/zy_response.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/toast_kit.dart';
// import 'package:taojuwu/view/order/utils/order_kit.dart';
import 'package:taojuwu/view/product/mixin/target_product_holder.dart';

import 'abstract_curtain_product_detail_bean.dart';
import 'package:taojuwu/utils/common_kit.dart';

import 'style_selector/curtain_style_selector.dart';

abstract class BaseCurtainProductDetailBean
    extends AbstractCurtainProductDetailBean {
  static num defaultWidth;
  static num defaultHeight;
  List<ProductSkuAttr> originAttrList;
  List<ProductSkuAttr> attrList = []; // 窗纱 工艺方式 型材 里布 幔头 配饰等属性
  ProductSkuAttr roomAttr;
  OrderGoodsMeasureData measureData = OrderGoodsMeasureData();

  bool get isMeasureOrder => !CommonKit.isNullOrEmpty(measureData.orderGoodsId);

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

  String get currentSelectedWindowGauzeOptionName =>
      attrList
          ?.firstWhere((element) => element?.type == 3, orElse: () => null)
          ?.data
          ?.firstWhere((element) => element?.isChecked == true,
              orElse: () => null)
          ?.name ??
      '';

  BaseCurtainProductDetailBean.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    defaultWidth ??= CommonKit.parseDouble(json['width'], defaultVal: 3.5);
    defaultHeight ??= CommonKit.parseDouble(json['height'], defaultVal: 2.65);

    measureData.widthCM = width == null || width == 0 ? null : width * 100;
    measureData.heightCM = height == null || height == 0 ? null : height * 100;
  } //空间属性

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
          'value': widthCM ?? 0,
        },
        {'name': '高', 'value': heightCM ?? 0}
      ]
    });

    return params;
  }

  //窗帘面积
  double get area {
    double _area = widthM * heightM;
    return _area > 0
        ? _area < 1
            ? 1
            : _area
        : 0;
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
    final List<ProductSkuAttrBean> list = attr?.data ?? [];
    if (attr.canMultiSelect) {
      ProductSkuAttrBean bean = list[i];
      bean.isChecked = !bean.isChecked;
    } else {
      for (int j = 0; j < list.length; j++) {
        ProductSkuAttrBean bean = list[j];
        bean.isChecked = i == j;
      }
    }

    if (attr?.type == 3) {
      filter();
    }
    if (attr?.type == 4) {
      ProductSkuAttr partAttr =
          originAttrList?.firstWhere((e) => e.type == 5, orElse: () => null);

      partSkuAttr?.data = filterPart(partAttr?.data);
      selectFirstItem(partSkuAttr?.data);
    }
  }

  void filter() {
    originAttrList ??= copyAttrs();

    ProductSkuAttr craftAttr =
        originAttrList?.firstWhere((e) => e.type == 4, orElse: () => null);

    // selectFirstItem(craftAttr?.data);
    craftSkuAttr?.data = filterCraft(craftAttr?.data)
        ?.map((e) => ProductSkuAttrBean.fromJson(e.toMap()))
        ?.toList();
    selectFirstItem(craftSkuAttr?.data);
    ProductSkuAttr partAttr =
        originAttrList?.firstWhere((e) => e.type == 5, orElse: () => null);
    // partAttr?.data = filterCraft(partAttr?.data)
    //     ?.map((e) => ProductSkuAttrBean.fromJson(e.toMap()))
    //     ?.toList();
    partSkuAttr?.data = filterPart(partAttr?.data)
        ?.map((e) => ProductSkuAttrBean.fromJson(e.toMap()))
        ?.toList();
    selectFirstItem(partSkuAttr?.data);
    print('___________');
  }

  List<ProductSkuAttrBean> selectFirstItem(List<ProductSkuAttrBean> list) {
    if (!CommonKit.isNullOrEmpty(list)) {
      for (int i = 0; i < list?.length; i++) {
        ProductSkuAttrBean e = list[i];
        e?.isChecked = i == 0;
      }
    }
    return list;
  }

  OrderGoodsMeasureData copyMeasureData() {
    return OrderGoodsMeasureData(
        heightCM: heightCM, widthCM: widthCM, deltaYCM: deltaYCM);
  }

  ProductSkuAttrBean getSelectedElement(int type) {
    List<ProductSkuAttrBean> list = getSelectedElementList(type);
    if (CommonKit.isNullOrEmpty(list)) return null;
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
    if (CommonKit.isNullOrEmpty(list)) return null;
    return list?.where((element) => element.isChecked)?.toList();
  }

  // 商品单价
  double get unitPrice {
    return price ?? 0.00;
  }

  set unitPrice(double v) {
    price = v;
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
    if (heightCM > 350 && isFixedHeight) {
      ToastKit.showInfo('暂不支持3.5m以上定制');
      return false;
    }
    return true;
  }

  bool get isValidSize => _isValidWidth() && _isValidHeight();

  bool get isDefaultMeasureData =>
      measureData?.widthM == defaultWidth &&
      measureData?.heightM == defaultHeight;

  Future addToCartRequest() {
    developer.log(cartArgs?.toString());
    return OTPService.addCart(params: cartArgs).then((ZYResponse response) {
      if (response?.valid == true) {
        ToastKit.showSuccessDIYInfo('加入购物车成功');
        Application.eventBus.fire(AddToCartEvent(response?.data));
      } else {
        ToastKit.showErrorInfo(response?.message);
      }
    }).catchError((err) => err);
  }

  // // 测装数据参数
  // Map<String, dynamic> get mesaureDataArg {
  //   return {
  //     'width': widthCM,
  //     'height': heightCM,
  //     'vertical_ground_height': deltaYCM,
  //     'goods_id': goodsId,
  //     'install_room': roomAttr?.selcetedAttrBean?.id,
  //   };
  // }

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
  Future addToCart(BuildContext context, {Function callback}) {
    if (hasSetSize()) {
      return saveMeasure(context)
          .then((value) => value != false ? addToCartRequest() : '');
    }
    if (callback != null) callback();
    return Future.value(false);
  }

  @override
  Future buy(BuildContext context, {Function callback}) {
    if (hasSetSize()) {
      return saveMeasure(context)
          .then((value) => value != false ? super.buy(context) : '');
    }
    if (callback != null) callback();
    return Future.value(false);
    // throw UnimplementedError();
  }

  bool hasSetSize() {
    if (measureData?.hasSetSize == false) {
      ToastKit.showInfo('请先填写测装数据哦');
      return false;
    }
    return true;
  }

  // 测装数据参数
  Map<String, dynamic> get mesaureDataArg {
    return {
      'dataId': styleSelector.styleOptionId,
      'width': widthCM,
      'height': heightCM,
      'vertical_ground_height': deltaYCM,
      'goods_id': goodsId,
      'install_room': roomAttr?.selcetedAttrBean?.id,
      // 'install_room': roomAttr?.selcetedAttrBean?.id,
      'data': jsonEncode({
        '${styleSelector.styleOptionId}': {
          'name': styleSelector.windowStyleStr,
          "install_room": "0",
          'w': '$widthCM',
          'h': '$heightCM',
          '13': attrList?.last?.toJson(),
          'selected': {
            '安装选项': [styleSelector?.curInstallMode?.name ?? ''],
            '打开方式': styleSelector?.openModeData
          }
        }
      })
    };
  }

  int get skuId => defalutSkuId;
  @override
  get cartArgs => {
        // 'measure_data': mesaureDataArg,
        'wc_attr': jsonEncode(attrArgs),
        'measure_id': measureData?.id,
        'estimated_price': totalPrice,
        'client_uid': clientId,
        'is_shade': 1,
        'cart_detail': jsonEncode({
          'sku_id': '$skuId',
          'goods_id': '$goodsId',
          'goods_name': '$goodsName',
          'shop_id': '$shopId',
          'price': '$price',
          'picture': '$picture',
          'num': '$count',
        })
      };

  List<ProductSkuAttrBean> filterCraft(List<ProductSkuAttrBean> list) {
    if (list?.isNotEmpty != true) return [];

    String keyword1 = r'打孔';
    List<ProductSkuAttrBean> temp1 = [];
    // 进行第一步筛选 根据有义务轨道

    // 有盒
    if (styleSelector?.getFirst(styleSelector?.boxOptionList)?.id == 2) {
      for (int i = 0; i < list?.length; i++) {
        ProductSkuAttrBean bean = list[i];
        if (bean?.name?.contains(keyword1) == true) {
          temp1.add(bean);
        }
      }
    } else {
      temp1 = list;
    }
    String keyword2 = '不要';

    String keyword3 = '单';
    String keyword4 = '双';

    // 进行第二步过滤
    List<ProductSkuAttrBean> temp2 = [];
    //不需要窗纱
    if (currentSelectedWindowGauzeOptionName?.contains(keyword2) == true) {
      for (int i = 0; i < temp1?.length; i++) {
        ProductSkuAttrBean item = temp1[i];
        if (item?.name?.contains(keyword3) == true &&
            temp2.contains(item) == false) {
          temp2.add(item);
        }
      }
    } else {
      for (int i = 0; i < temp1?.length; i++) {
        ProductSkuAttrBean item = temp1[i];
        print(item?.name?.contains(keyword4));
        if (item?.name?.contains(keyword4) == true) {
          temp2.add(item);
        }
      }
    }

    return temp2;
    // // 如果需要打孔
    // if (temp1?.isNotEmpty != true) return [];
    // if (curCanopyAttrBean?.name?.contains(keyword1) == true) {
    //   for (int i = 0; i < temp1.length; i++) {
    //     ProductSkuAttrBean bean = list[i];
    //     if (bean?.name?.contains(keyword2) == true) {
    //       temp2.add(bean);
    //     }
    //   }
    // } else {
    //   temp2 = temp1;
    // }

    // 第三步筛选
  }

  List<ProductSkuAttrBean> filterPart(List<ProductSkuAttrBean> list) {
    if (list?.isNotEmpty != true) return [];
    // 进行第一步筛选 根据有义务轨道
    String keyword0 = 'GD';
    List<ProductSkuAttrBean> temp1 = [];
    // 有盒
    if (styleSelector?.getFirst(styleSelector?.boxOptionList)?.id == 2) {
      for (int i = 0; i < list?.length; i++) {
        ProductSkuAttrBean bean = list[i];
        if (bean?.name?.contains(keyword0) == true) {
          temp1.add(bean);
        }
      }
    } else {
      temp1 = list;
    }
    // 进行第二步过滤
    String keyword1 = "打孔";
    String keyword2 = "LMG";

    List<ProductSkuAttrBean> temp2 = [];
    // 如果需要打孔
    if (temp1?.isNotEmpty != true) return [];
    if (craftSkuAttr?.selectedAttrName?.contains(keyword1) == true) {
      temp2 =
          temp1?.where((e) => RegexUtil.matches(keyword2, e.name))?.toList();
    } else {
      temp2 = temp1;
    }
    return temp2;
  }

  ProductSkuAttr get craftSkuAttr {
    if (attrList?.isNotEmpty != true) return null;
    return attrList?.firstWhere((e) => e.type == 4, orElse: () => null);
  }

  ProductSkuAttr get partSkuAttr {
    if (attrList?.isNotEmpty != true) return null;
    return attrList?.firstWhere((e) => e.type == 5, orElse: () => null);
  }

  bool get isUseDefaultSize =>
      measureData?.widthM == defaultWidth &&
      measureData?.heightM == defaultHeight;

  Future selectProduct(BuildContext context) {
    // Map<int, String> id2Name = {1: '布艺帘', 2: '卷帘'};
    if (measureData?.hasConfirmed == false) {
      ToastKit.showInfo('请先确认测装数据哦');
      return Future.value(false);
    }
    // if (TargetProductHolder.goodsType != goodsType) {
    //   return selectProductTipAfter(context,
    //       currentType: id2Name[goodsType ?? 1],
    //       targetType: TargetProductHolder.categoryName,
    //       callback: () => sendSelectProductRequest(context));
    // }
    return sendSelectProductRequest(context);
  }

  Future sendSelectProductRequest(BuildContext context) {
    Map<String, dynamic> data = {
      'num': 1,
      'goods_id': goodsId,
      '安装选项': ['${styleSelector.curInstallMode ?? ''}'],
      '打开方式': styleSelector.curOpenMode
    };
    Map<String, dynamic> params = {
      'vertical_ground_height': measureData?.deltaYCM,
      'data': jsonEncode(data),
      'wc_attr': jsonEncode(attrArgs),
      'order_goods_id': TargetProductHolder?.measureData?.orderGoodsId,
    };
    return OTPService.selectProduct(params: params).then((ZYResponse response) {
      if (response?.valid == true) {
        TargetProductHolder.clear();
        Navigator.of(context)..pop()..pop();
      } else {
        ToastKit.showInfo(response?.message);
      }
    });
  }
}
