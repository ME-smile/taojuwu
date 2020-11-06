/*
 * @Description: 订单创建的模型
 * @Author: iamsmiling
 * @Date: 2020-10-29 17:22:23
 * @LastEditTime: 2020-11-05 09:45:08
 */

import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product_detail/abstract/abstract_base_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/abstract/abstract_prodcut_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/abstract/multi_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/abstract/single_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/base_curtain_product_detail_bean.dart';
import 'package:taojuwu/repository/zy_response.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/singleton/target_client.dart';
import 'package:taojuwu/utils/toast_kit.dart';
import 'package:taojuwu/widgets/time_period_picker.dart';

class OrderCreator {
  TimePeriod measureTimePeriod;

  String get measureTimeStr => measureTimePeriod == null
      ? '时间'
      : '${DateUtil.formatDate(measureTimePeriod?.dateTime, format: 'yyyy年MM月dd日') ?? ''} ${measureTimePeriod?.period ?? ''}' ??
          '';
  String installTime;

  AbstractProductDetailBean productDetailBean;

  List<SingleProductDetailBean> get goodsList =>
      productDetailBean is SingleProductDetailBean
          ? [productDetailBean]
          : (productDetailBean as MultiProductDetailBean)?.goodsList;

  String windowCount;

  // 定金金额
  String depositAmount;

  String extraRemark;

  TargetClient targetClient;

  bool get isClientNull => targetClient == null;

  int get clientId => targetClient?.clientId;

  int get addressId => targetClient?.addressId;

  OrderCreator.fromProduct(AbstractBaseProductDetailBean bean) {
    productDetailBean = bean;
    targetClient = productDetailBean?.client;
  }

  OrderCreator();

  bool isValidOrderInfo() {
    if (isClientNull) {
      ToastKit.showInfo('请选择客户');
      return false;
    }
    if (addressId == null) {
      ToastKit.showInfo('请填写收货地址');
      return false;
    }
    if (measureTimeStr == null || measureTimeStr?.trim()?.isEmpty == true) {
      ToastKit.showInfo('请选择上门量尺意向时间');
      return false;
    }
    if (installTime == null || installTime?.trim()?.isEmpty == true) {
      ToastKit.showInfo('请选择客户意向安装时间');
      return false;
    }
    if (depositAmount == null || depositAmount?.trim()?.isEmpty == true) {
      ToastKit.showInfo('请输入定金');
      return false;
    }
    return true;
  }

  bool get isEndPorductOrder =>
      productDetailBean?.productType == ProductType.EndProductType;

  num get deltaYCM => productDetailBean is BaseCurtainProductDetailBean
      ? (productDetailBean as BaseCurtainProductDetailBean)?.deltaYCM
      : 0;
  String get measureId {
    List<int> idList = [];
    goodsList?.forEach((e) {
      int id = e is BaseCurtainProductDetailBean ? e?.measureData?.id : 0;
      idList.add(id);
    });
    return idList.join(',');
  }

  List<String> get attrStrList {
    List<String> list = [];
    goodsList?.forEach((e) {
      String attr =
          e is BaseCurtainProductDetailBean ? jsonEncode(e.attrArgs) : '0';
      list.add(attr);
    });
    return list;
  }

  String get goodsSkuListStr {
    return goodsList
        ?.map((e) =>
            '${e?.skuId ?? ''}:${e?.count ?? ''}:0:${e?.totalPrice ?? ''}')
        ?.toList()
        ?.join(',');
  }

  Map<String, dynamic> get orderArgs {
    print({
      'order_earnest_money': depositAmount,
      'client_uid': clientId,
      'vertical_ground_height': deltaYCM,
      'measure_id': measureId,
      'measure_time': measureTimeStr,
      'install_time': installTime,
      'order_remark': extraRemark,
      'wc_attr': jsonEncode(attrStrList),
      'data': '''{
          "order_type": "1",
          "point": "0",
          "pay_type": "10",
          "shipping_info": {"shipping_type": "1", "shipping_company_id": "0"},
          "address_id": "$addressId",
          "coupon_id": "0",
          "order_tag": "2",
          "goods_sku_list":"$goodsSkuListStr"
      }''',
    });
    return {
      'order_earnest_money': depositAmount,
      'client_uid': clientId,
      'vertical_ground_height': deltaYCM,
      'measure_id': measureId,
      'measure_time': measureTimeStr,
      'install_time': installTime,
      'order_remark': extraRemark,
      'wc_attr': jsonEncode(attrStrList),
      'data': '''{
          "order_type": "1",
          "point": "0",
          "pay_type": "10",
          "shipping_info": {"shipping_type": "1", "shipping_company_id": "0"},
          "address_id": "$addressId",
          "coupon_id": "0",
          "order_tag": "2",
          "goods_sku_list":"$goodsSkuListStr"
      }''',
    };
  }

  Map<String, dynamic> get measureOrderArgs {
    return {
      'client_uid': clientId,
      'measure_time': measureTimeStr,
      'install_time': installTime,
      'order_earnest_money': depositAmount,
      'order_remark': extraRemark,
      'order_window_num': windowCount,
    };
  }

  Future createMeasureOrder(BuildContext context) {
    if (!isValidOrderInfo()) return Future.value(false);
    return _sendCreateMeasureOrderRequest(context);
  }

  Future _sendCreateMeasureOrderRequest(BuildContext context) {
    return OTPService.createMeasureOrder(params: measureOrderArgs)
        .then((ZYResponse response) {
      if (response?.valid == true) {
        return RouteHandler.goOrderCommitSuccessPage(context, '$clientId',
            orderType: 2, showTip: 1);
      }
      ToastKit.showErrorInfo(response?.message ?? '');
    }).catchError((err) => err);
  }

  Future createOrder(BuildContext context) {
    if (!isEndPorductOrder) {
      if (!isValidOrderInfo()) return Future.value(false);
    }
    return _sendCreateOrderRequest(context);
  }

  Future _sendCreateOrderRequest(BuildContext context) {
    return OTPService.createOrder(params: orderArgs)
        .then((ZYResponse response) {
      print(response?.data);
      if (response?.valid == true) {
        return RouteHandler.goOrderCommitSuccessPage(context, '$clientId',
            orderType: 2, showTip: 1);
      }
      ToastKit.showErrorInfo(response?.message ?? '');
    }).catchError((err) => err);
  }
}
