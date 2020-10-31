/*
 * @Description: 填写定金对话框
 * @Author: iamsmiling
 * @Date: 2020-10-29 17:59:23
 * @LastEditTime: 2020-10-30 07:57:22
 */
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/view/order/dialog/order_deposit_remark_dialog_android_view.dart';
import 'package:taojuwu/view/order/dialog/order_deposit_remark_dialog_ios_view.dart';
import 'package:taojuwu/viewmodel/order/order_creator.dart';

import 'order_extra_remark_dialog_android_view.dart';
import 'order_extra_remark_dialog_ios_view.dart';

Future showDespositRemarkDialog(
    BuildContext context, OrderCreator orderCreator) {
  if (Platform.isAndroid) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return OrderDepositRemarkDialogAndroidView(orderCreator);
        });
  }
  return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return OrderDepositRemarkDialogIosView(orderCreator);
      });
}

Future showOrderExtraRemarkDialog(
    BuildContext context, OrderCreator orderCreator) {
  if (Platform.isAndroid) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return OrderExtraRemarkDialogAndroidView(orderCreator);
        });
  }
  return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return OrderExtraRemarkDialogIosView(orderCreator);
      });
}
