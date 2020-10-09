/*
 * @Description: 普通窗帘单
 * @Author: iamsmiling
 * @Date: 2020-10-09 09:33:19
 * @LastEditTime: 2020-10-09 10:21:36
 */

import 'base_curtain_order_creator.dart';

class CommonCurtainOrderCreator extends BaseCurtainOrderCreator {
  @override
  Map<String, dynamic> get params => {
        'order_earnest_money': depositMoney,
        'client_uid': client?.clientId,
        'shop_id': shopId,
        'measure_time': measureTime,
        'install_time': installTime,
        'order_remark': remark,
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
  bool isOrderInfoValid() {
    return isMeasureTimeValid() &&
        isInstallTimeValid() &&
        isDepositMoneyValid();
  }
}
