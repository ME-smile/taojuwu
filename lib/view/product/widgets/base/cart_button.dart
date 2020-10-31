/*
 * @Description: 加入购物车按钮
 * @Author: iamsmiling
 * @Date: 2020-10-28 15:04:13
 * @LastEditTime: 2020-10-31 13:16:15
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:taojuwu/application.dart';
import 'package:taojuwu/event_bus/events/add_to_cart_event.dart';
import 'package:taojuwu/event_bus/events/select_client_event.dart';
import 'package:taojuwu/repository/shop/cart_list_model.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/utils/toast_kit.dart';
import 'package:taojuwu/utils/ui_kit.dart';

class CartButton extends StatefulWidget {
  final int count;
  const CartButton({Key key, this.count = 0}) : super(key: key);

  @override
  _CartButtonState createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  static int count = 0;

  int clientId;

  //监听选择客户的事件
  StreamSubscription _subscription;
  @override
  void initState() {
    _subscription = Application.eventBus.on().listen((event) {
      if (event is SelectClientEvent) {
        clientId = event.mTargetClient.clientId;
        _fetchData();
      }
      if (event is AddToCartEvent) {
        mounted
            ? setState(() {
                count = event.count;
              })
            // ignore: unnecessary_statements
            : '';
      }
    });
    super.initState();
  }

  Future _fetchData() {
    return OTPService.cartCount(context, params: {
      'client_uid': clientId,
    })
        .then((CartCountResp response) {
          count = CommonKit.parseInt(response?.data);
          print(count);
        })
        .catchError((err) => err)
        .whenComplete(() {
          setState(() {});
        });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    count = 0;
    super.dispose();
  }

  Future _jump(BuildContext context) {
    if (clientId == null) {
      ToastKit.showInfo('请先选择客户哦');
      return Future.value(false);
    }
    return RouteHandler.goCartPage(context, clientId: clientId);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _jump(context),
      child: Container(
        width: UIKit.width(60),
        height: UIKit.width(60),
        margin: EdgeInsets.only(bottom: 5),
        alignment: Alignment(0.8, -0.8),
        child: Visibility(
          child: Container(
            width: 16,
            height: 16,
            alignment: Alignment.center,
            child: Text(
              '$count',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: count > 10 ? 10 : 12,
                  fontFamily: 'Roboto'),
            ),
            decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(8))),
          ),
          visible: !CommonKit.isNumNullOrZero(count),
        ),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
          UIKit.getAssetsImagePath(
            'cart_blank.png',
          ),
        ))),
      ),
    );
  }
}
