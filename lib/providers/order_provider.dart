import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/models/order/order_cart_goods_model.dart';
import 'package:taojuwu/models/zy_response.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/common_kit.dart';

import 'client_provider.dart';
import 'user_provider.dart';

class OrderProvider with ChangeNotifier {
  List<OrderCartGoods> orderGoods;
  final int orderType;
  final BuildContext context;

  OrderProvider(
    this.context, {
    this.orderType: 1,
    this.orderGoods,
  });
  double get totalPrice {
    double sum = 0.00;
    orderGoods?.forEach((item) {
      sum += item?.totalPrice ?? 0.00;
    });
    return sum;
  }

  String get addressId =>
      Provider.of<ClientProvider>(context, listen: false).addressId;
  String get clientUid =>
      '${Provider.of<ClientProvider>(context, listen: false).clientId ?? ''}';
  String get shopId =>
      '${Provider?.of<UserProvider>(context, listen: false)?.userInfo?.shopId ?? ''}';
  String get goodsSkuListText =>
      orderGoods
          ?.map((item) =>
              '${item?.skuId ?? ''}:${item?.count ?? ''}:${item?.isShade ?? ''}:${item?.totalPrice ?? ''}')
          ?.toList()
          ?.join(',') ??
      '';
  String get cartId =>
      orderGoods?.map((item) => item.cartId)?.toList()?.join(',');
  List<String> get attr => orderGoods?.map((item) => item.attr)?.toList() ?? [];

  int get totalCount => orderGoods?.length ?? 0;

  String _measureTime;
  String _installTime;
  String _orderMark;
  String _deposit;

  String get measureTime => _measureTime;
  String get installTime => _installTime;
  String get orderMark => _orderMark;
  String get deposit => _deposit;

  set orderMark(String orderMark) {
    _orderMark = orderMark;
    notifyListeners();
  }

  set deposit(String amount) {
    _deposit = amount;
    notifyListeners();
  }

  set measureTime(String date) {
    _measureTime = date;
    notifyListeners();
  }

  set installTime(String date) {
    _installTime = date;
    notifyListeners();
  }

  bool beforeCreateOrder() {
    // debugPrint({
    //   'order_earnest_money': deposit,
    //   'cart_id':cartId??'',
    //   'client_uid': clientUid,
    //   'shop_id': shopId,
    //   'measure_id':
    //       '${orderGoods?.map((item) => item.measureId)?.toList()?.join(',')}',
    //   'measure_time': measureTime,
    //   'install_time': installTime,
    //   'order_remark': orderMark,
    //   'wc_attr': jsonEncode(attr),
    //   'data': '''{
    //       "order_type": "$orderType",
    //       "point": "0",
    //       "pay_type": "0",
    //       "shipping_info": {"shipping_type": "1", "shipping_company_id": "0"},
    //       "address_id": "$addressId",
    //       "coupon_id": "0",
    //       "order_tag": "2",
    //       "goods_sku_list": "$goodsSkuListText"
    //     }'''
    // }.toString(),);
    log({
      'order_earnest_money': deposit,
      'cart_id': cartId ?? '',
      'client_uid': clientUid,
      'shop_id': shopId,
      'measure_id':
          '${orderGoods?.map((item) => item.measureId)?.toList()?.join(',')}',
      'measure_time': measureTime,
      'install_time': installTime,
      'order_remark': orderMark,
      'wc_attr': jsonEncode(attr),
      'data': '''{
          "order_type": "$orderType",
          "point": "0",
          "pay_type": "0",
          "shipping_info": {"shipping_type": "1", "shipping_company_id": "0"},
          "address_id": "$addressId",
          "coupon_id": "0",
          "order_tag": "2",
          "goods_sku_list": "$goodsSkuListText"
        }'''
    }.toString());
    if (addressId == null || addressId?.isEmpty == true) {
      CommonKit.toast(context, '请填写收货人');
      return false;
    }
    if (measureTime == null || measureTime?.trim()?.isEmpty == true) {
      CommonKit.toast(context, '请选择上门量尺意向时间');
      return false;
    }
    if (installTime == null || installTime?.trim()?.isEmpty == true) {
      CommonKit.toast(context, '请选择客户意向安装时间');
      return false;
    }
    if (deposit == null || deposit?.trim()?.isEmpty == true) {
      CommonKit.toast(context, '请输入定金');
      return false;
    }
    return true;
  }

  void createOrder() {
    if (!beforeCreateOrder()) return;
    OTPService.createOrder(
      context,
      params: {
        'order_earnest_money': deposit,
        'client_uid': clientUid,
        'shop_id': shopId,
        'measure_id':
            '${orderGoods?.map((item) => item.measureId)?.toList()?.join(',')}',
        'measure_time': measureTime,
        'install_time': installTime,
        'order_remark': orderMark,
        'wc_attr': jsonEncode(attr),
        'data': '''{
          "order_type": "$orderType",
          "point": "0",
          "pay_type": "10",
          "shipping_info": {"shipping_type": "1", "shipping_company_id": "0"},
          "address_id": "$addressId",
          "coupon_id": "0",
          "order_tag": "2",
          "goods_sku_list": "$goodsSkuListText"
        }'''
      },
    ).then((ZYResponse response) {
      CommonKit.toast(context, response.message ?? '');
      if (response.valid) {
        RouteHandler.goOrderCommitSuccessPage(context);
      }
    }).catchError((err) => err);
  }
}
