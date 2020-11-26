/*
 * @Description: 
 * @Author: iamsmiling
 * @Date: 2020-10-31 13:34:35
 * @LastEditTime: 2020-11-26 10:59:24
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/utils/toast_kit.dart';

class ZYResponse<T> {
  int code;
  String message;
  T data;

  ZYResponse({this.code, this.data, this.message});
  bool get valid {
    return code == 0;
  }

  void showError(BuildContext context) {
    if (valid) return;
    ToastKit.showToast(message ?? '未知错误');
  }

  ZYResponse.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      this.code = json['code'].runtimeType == int
          ? json['code']
          : int.parse(json['code']);
      this.message = json['msg'] ?? json['message'] ?? '';
    }
  }

  ZYResponse.fromJsonWithData(Map<String, dynamic> json) {
    this.code = json['code'].runtimeType == int
        ? json['code']
        : int.parse(json['code']);
    this.message = json['msg'] ?? json['message'] ?? '';
    this.data = json['data'];
  }

  Map toJson() => {'code': code, 'data': data, 'messgse': message};
}
