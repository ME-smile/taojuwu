/*
 * @Description: 创建订单的接口
 * @Author: iamsmiling
 * @Date: 2020-09-25 13:48:40
 * @LastEditTime: 2020-09-25 13:50:24
 */

import 'package:taojuwu/singleton/target_client.dart';
import 'package:taojuwu/viewmodel/order/binding/selector_client_binding.dart';

abstract class OrderCreator with ClientSelectorBinding {
  // 选择用户

  TargetClient selectClient();

  //填写地址信息等
  TargetClient fillUserInfo();

  //提交订单
  createOrder();
}
