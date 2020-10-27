/*
 * @Description: 商品provider的基类，混入changeNotifier,具有刷新的功能
 * @Author: iamsmiling
 * @Date: 2020-10-20 18:12:25
 * @LastEditTime: 2020-10-23 13:32:53
 */
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:taojuwu/application.dart';
import 'package:taojuwu/event_bus/events/select_client_event.dart';
import 'package:taojuwu/repository/shop/cart_list_model.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/viewmodel/product/base/provider/abstract_base_product_provider.dart';

class BaseProductProvider extends AbstractBaseProductProvider
    with ChangeNotifier {
  // 通知页面刷新
  refresh() {
    notifyListeners();
  }

  int get goodsId => productBean?.goodsId;

  int get clientId => targetClient?.clientId;

  set clientId(int id) {
    targetClient?.clientId = id;
  }

  //监听选择客户的事件
  StreamSubscription _subscription;
  @override
  void addListener(listener) {
    _subscription =
        Application.eventBus.on<SelectClientEvent>().listen((event) {
      clientId = event.mTargetClient.clientId;
      _getCartCount();
    });
    super.addListener(listener);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future _getCartCount() {
    return OTPService.cartCount(context,
            params: {'client_uid': clientId, 'goods_id': goodsId})
        .then((CartCountResp cartCountResp) {
          goodsCountInCart = CommonKit.parseInt(cartCountResp?.data);
        })
        .catchError((err) => err)
        .whenComplete(refresh);
  }
}
