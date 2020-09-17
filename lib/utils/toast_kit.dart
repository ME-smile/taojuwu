import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:taojuwu/icon/ZYIcon.dart';

class ToastKit {
  static initEasyLoading() {
    EasyLoading.instance
      ..successWidget = Icon(
        ZYIcon.check,
        color: Colors.white,
        size: 36,
      )
      ..infoWidget = Icon(
        ZYIcon.exclamation_point,
        color: Colors.white,
        size: 30,
      )
      ..errorWidget = Icon(
        ZYIcon.close,
        color: Colors.white,
        size: 40,
      );
  }

  static Function once(Function fn, [List args]) {
    var result;
    return () {
      if (fn != null) {
        result = Function.apply(fn, [] + args);
        fn = null;
      }
      return result;
    };
  }

  static void showSuccess() {
    EasyLoading.showSuccess('提交成功');
  }

  static void showLoading() {
    EasyLoading.instance.maskColor = Colors.black;
    EasyLoading.show(status: '正在加载');
  }

  static void showError() {
    EasyLoading.showError('网络错误');
  }

  static void showErrorInfo(String msg) {
    EasyLoading.showError(msg);
  }

  static void showToast(String msg) {
    EasyLoading.showToast(msg);
  }

  static void showSuccessDIYInfo(String msg) {
    EasyLoading.showSuccess(msg);
  }

  static void showInfo(String msg) {
    EasyLoading.showInfo(msg);
  }

  static void dismiss() {
    EasyLoading.dismiss();
  }
}
