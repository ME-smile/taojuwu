/*
 * @Description: 商品尺寸相关的逻辑
 * @Author: iamsmiling
 * @Date: 2020-09-27 09:16:44
 * @LastEditTime: 2020-09-30 16:36:36
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/order/order_detail_model.dart';
import 'package:taojuwu/repository/shop/sku_attr/curtain_sku_attr.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/utils/toast_kit.dart';
import 'package:taojuwu/viewmodel/goods/binding/base/curtain_goods_binding.dart';

mixin CurtainSizeFillerBinding on CurtainGoodsBinding {
  List<CurtainSkuAttr> curtainSkuAttrList = [];

  TextEditingController widthController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController deltaYController = TextEditingController();

  OrderGoodsMeasure measureData; //测装数据
  String get widthCMStr => widthController.text; //输入框输入的宽度-->以厘米为单位
  String get heightCMStr => heightController.text; // 输入框输入的高度-->以厘米为单位
  String get deltaYCMStr => deltaYController.text; // 输入框输入的离地距离-->以厘米为单位

  double get widthCM => CommonKit.parseDouble(widthCMStr, defaultVal: 0.0);

  double get heightCM => CommonKit.parseDouble(heightCMStr, defaultVal: 0.0);

  double get deltaYCM => CommonKit.parseDouble(deltaYCMStr, defaultVal: 0.0);

  // 将CM转化为M 为单位
  double get widthM => CommonKit.toDoubleAsFixed(widthCM / 100);

  double get heightM => CommonKit.toDoubleAsFixed(heightCM / 100);

  bool hasSetSize = false;

  String get sizeText =>
      hasSetSize ? '宽 ${widthM ?? ''}米 高${heightM ?? ''}米' : '尺寸';

  String get dyCMStr => '$deltaYCM cm';
  // 是否为定高
  bool get isFixedHeight => bean?.fixHeight == 0;

  CurtainType get curtainType {
    if (bean?.goodsSpecialType == 2) {
      return CurtainType.WindowRollerType;
    }

    if (bean?.goodsSpecialType == 3) {
      return CurtainType.WindowGauzeType;
    }
    return CurtainType.WindowSunblind;
  }

  bool get isWindowGauze =>
      curtainType == CurtainType.WindowGauzeType; // 商品是否为窗帘

  bool get isWindowRoller =>
      curtainType == CurtainType.WindowRollerType; //商品是否为卷帘

  //窗帘面积
  double get area {
    double _area = widthM * heightM;
    return _area > 0 ? _area < 1 ? 1 : _area : 0;
  }

  @override
  void addListener(listener) {
    super.addListener(listener);
  }

/*
 * @Author: iamsmiling
 * @description: 监听宽度、高度、离地距离的变化
 * @param : 
 * @return {type} 
 * @Date: 2020-09-27 09:34:44
 */

  // 校验宽度
  bool _isValidWidth() {
    if (widthCMStr == null || widthCMStr.isEmpty) {
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
    if (heightCMStr == null || heightCMStr.isEmpty) {
      ToastKit.showInfo('请填写高度');
      return false;
    }
    if (heightCM == 0) {
      ToastKit.showInfo('高度不能为0哦');
      return false;
    }
    if (heightCM > 350) {
      ToastKit.showInfo('暂不支持3.5m以上定制');
      heightController.text = '350';
      return false;
    }
    return true;
  }

  bool _isValidSize() {
    return _isValidWidth() && _isValidHeight();
  }

  // 提交测装数据
  Future commitSize() async {
    notifyListeners();
    if (!_isValidSize()) return;
  }
/*
 * @Author: iamsmiling
 * @description: 添加监听器
 * @param : 
 * @return {type} 
 * @Date: 2020-09-27 09:38:12
 */

  void _dispose() {
    widthController?.dispose();
    heightController?.dispose();
    deltaYController?.dispose();
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }
}
