/*
 * @Description: 商品尺寸相关的逻辑
 * @Author: iamsmiling
 * @Date: 2020-09-27 09:16:44
 * @LastEditTime: 2020-09-27 16:16:05
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/order/order_detail_model.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/viewmodel/goods/binding/base/curtain_goods_binding.dart';

mixin CurtainSizeFillerBinding on CurtainGoodsBinding {
  TextEditingController _widthController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _deltaYController = TextEditingController();

  OrderGoodsMeasure measureData; //测装数据
  String widthCMStr; //输入框输入的宽度-->以厘米为单位
  String heightCMStr; // 输入框输入的高度-->以厘米为单位
  String deltaYCMStr; // 输入框输入的离地距离-->以厘米为单位

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
    _addListeners();
    super.addListener(listener);
  }

/*
 * @Author: iamsmiling
 * @description: 监听宽度、高度、离地距离的变化
 * @param : 
 * @return {type} 
 * @Date: 2020-09-27 09:34:44
 */
  void _listenWidthChange() {
    widthCMStr = _widthController.text;
    notifyListeners();
  }

  void _listenHeightChange() {
    heightCMStr = _widthController.text;
    notifyListeners();
  }

  void _listenDeltaYChange() {
    deltaYCMStr = _widthController.text;
    notifyListeners();
  }

/*
 * @Author: iamsmiling
 * @description: 添加监听器
 * @param : 
 * @return {type} 
 * @Date: 2020-09-27 09:38:12
 */

  void _addListeners() {
    _widthController?.addListener(_listenWidthChange);
    _heightController?.addListener(_listenHeightChange);
    _deltaYController?.addListener(_listenDeltaYChange);
  }

  void _removeListeners() {
    _widthController?.removeListener(_listenWidthChange);
    _heightController?.removeListener(_listenHeightChange);
    _deltaYController?.removeListener(_listenDeltaYChange);
  }

  void _dispose() {
    _widthController?.dispose();
    _heightController?.dispose();
    _deltaYController?.dispose();
  }

  @override
  void dispose() {
    _removeListeners();
    _dispose();
    super.dispose();
  }
}
