/*
 * @Description: 窗帘定创建基类
 * @Author: iamsmiling
 * @Date: 2020-10-09 09:34:59
 * @LastEditTime: 2020-12-22 10:24:39
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/utils/toast_kit.dart';
import 'package:taojuwu/viewmodel/order/base/base_order_creator.dart';

abstract class BaseCurtainOrderCreator extends BaseOrderCreator {
  BuildContext context;
  String measureTime; // 上门量尺意向时间-->必填
  String installTime; //客户意向安装时间-->必填
  double depositMoney = 0.0; //定金。默认为0-->必填
  String remark; // 订单备注-->选填

  bool isMeasureTimeValid() {
    // if (CommonKit.isNullOrEmpty(measureTime)) {
    //   ToastKit.showInfo('请填写上门量尺意向时间');
    //   return false;
    // }
    return true;
  }

  bool isInstallTimeValid() {
    // if (CommonKit.isNullOrEmpty(measureTime)) {
    //   ToastKit.showInfo('请填写客户意向安装时间');
    //   return false;
    // }
    return true;
  }

  bool isDepositMoneyValid() {
    if (CommonKit.isNumNullOrZero(depositMoney)) {
      ToastKit.showInfo('定金不能为0哦');
      return false;
    }
    return true;
  }
}
