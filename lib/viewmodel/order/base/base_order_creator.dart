/*
 * @Description: 订单创建对象的基类
 * @Author: iamsmiling
 * @Date: 2020-09-28 09:21:30
 * @LastEditTime: 2020-10-29 15:50:40
 */

import 'package:flutter/cupertino.dart';
import 'package:taojuwu/repository/shop/product/abstract/abstract_base_product_bean.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/singleton/target_client.dart';
import 'package:taojuwu/utils/toast_kit.dart';

abstract class BaseOrderCreator with ChangeNotifier {
  // 目标客户
  TargetClient client;

  //商品
  AbstractBaseProductBean productBean;

  int get clientId => client?.clientId;

  String get clientName => client?.clientName;

  String get tel => client?.tel;

  String get address => client?.address;

  // 门店id
  int shopId;

  // 创建订单
  Future<dynamic> create() {
    if (isClientInfoValid && isOrderInfoValid) {
      return sendRequest(params);
    }
    return Future.value(false);
  }

  //判断是否选择目标客户
  bool get _hasSelectedClient => client != null;

  //判断是否填写收货地址
  bool get _isAddressIdNull => client.addressId != null;

  bool get hasSelectedClient {
    if (!_hasSelectedClient) {
      ToastKit.showInfo('请选择客户哦');
      return false;
    }
    return true;
  }

  // 判断用户信息是否有效
  bool get isClientInfoValid {
    if (hasSelectedClient) return false;
    if (!_isAddressIdNull) {
      ToastKit.showInfo('请填写收获地址');
      return false;
    }
    return true;
  }

  // 判断订单信息是否有效
  bool get isOrderInfoValid;

  // 获取请求参数
  Map<String, dynamic> get params;

  // 发起网络请求
  Future<dynamic> sendRequest(Map<String, dynamic> params) {
    return OTPService.createOrder(params: params);
  }
}
