/*
 * @Description: 测量单下单操作
 * @Author: iamsmiling
 * @Date: 2020-10-09 09:48:24
 * @LastEditTime: 2020-10-29 15:45:09
 */

import 'package:flutter/material.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/utils/toast_kit.dart';

import 'base_curtain_order_creator.dart';

class MeasureCurtainOrderCreator extends BaseCurtainOrderCreator {
  int _windowNum;

  //构造方法
  MeasureCurtainOrderCreator(BuildContext ctx, int shopId) {
    context = ctx;
  }

  @override
  Map<String, dynamic> get params => {
        'order_earnest_money': depositMoney,
        'client_uid': client?.clientId,
        'shop_id': shopId,
        'measure_time': measureTime,
        'install_time': installTime,
        'order_remark': remark,
        'order_window_num': _windowNum,
        'data': '''{
          "order_type": 1,
          "point": "0",
          "pay_type": "10",
          "shipping_info": {"shipping_type": "1", "shipping_company_id": "0"},
          "address_id": "${client?.addressId}",
          "coupon_id": "0",
          "order_tag": "2"
        }'''
      };

  @override
  bool get isOrderInfoValid {
    return isMeasureTimeValid() &&
        isInstallTimeValid() &&
        isWindowNumValid() &&
        isDepositMoneyValid();
  }

  bool isWindowNumValid() {
    if (CommonKit.isNumNullOrZero(_windowNum)) {
      ToastKit.showInfo('测量窗数不能为0哦');
      return false;
    }
    return true;
  }
}
