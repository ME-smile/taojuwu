/*
 * @Description: 窗帘 商品 多了测装数据
 * @Author: iamsmiling
 * @Date: 2020-09-27 16:19:01
 * @LastEditTime: 2020-09-27 16:37:33
 */
import 'dart:async';

import 'package:taojuwu/application.dart';
import 'package:taojuwu/event_bus/events/select_product_event.dart';
import 'package:taojuwu/repository/order/measure_data_model.dart';
import 'package:taojuwu/repository/order/order_detail_model.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/viewmodel/goods/binding/base/base_goods_binding.dart';

enum CurtainType {
  WindowSunblind, //普通窗帘

  WindowGauzeType, //窗纱

  WindowRollerType //卷帘
}

mixin CurtainGoodsBinding implements BaseGoodsBinding {
  OrderGoodsMeasure measureData; //测装数据
  int orderGoodsId; // 测量单选品时多有一个  ordergoodsId

  // 从接口获取测装数据
  Future<MeasureDataModelResp> getMeasureData() {
    return OTPService.getMeasureData(context,
        params: {'order_goods_id': orderGoodsId});
  }

  StreamSubscription _streamSubscription;

  // 监听去选品事件
  @override
  void addListener(listener) {
    _streamSubscription =
        Application.eventBus.on<SelectProductEvent>().listen((event) {
      orderGoodsId = event.orderGoodsId;
    });
  }

  // 释放资源
  @override
  void dispose() {
    _streamSubscription?.cancel();
  }
}
