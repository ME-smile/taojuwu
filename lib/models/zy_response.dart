import 'package:flutter/material.dart';
import 'package:taojuwu/utils/common_kit.dart';

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
    CommonKit.showToast(message ?? '未知错误');
  }

  ZYResponse.fromJson(Map<String, dynamic> json) {
    this.code = json['code'].runtimeType == int
        ? json['code']
        : int.parse(json['code']);
    this.message = json['msg'] ?? json['message'] ?? '';
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
