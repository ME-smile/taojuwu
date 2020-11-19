/*
 * @Description: 买家信息栏目条条
 * @Author: iamsmiling
 * @Date: 2020-10-29 15:51:56
 * @LastEditTime: 2020-10-30 09:35:45
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:taojuwu/application.dart';
import 'package:taojuwu/event_bus/events/select_client_event.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/singleton/target_client.dart';
import 'package:taojuwu/utils/toast_kit.dart';
import 'package:taojuwu/viewmodel/order/order_creator.dart';

class OrderBuyerCard extends StatefulWidget {
  final OrderCreator orderCreator;
  OrderBuyerCard(this.orderCreator, {Key key}) : super(key: key);

  @override
  _OrderBuyerCardState createState() => _OrderBuyerCardState();
}

class _OrderBuyerCardState extends State<OrderBuyerCard> {
  OrderCreator get orderCreator => widget.orderCreator;
  TargetClient get client => orderCreator?.targetClient;

  StreamSubscription _subscription;

  @override
  void initState() {
    _subscription =
        Application.eventBus.on<SelectClientEvent>().listen((event) {
      orderCreator.targetClient = event.mTargetClient;
      // ignore: unnecessary_statements
      mounted ? setState(() {}) : '';
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme accentTextTheme = themeData.accentTextTheme;
    return GestureDetector(
        onTap: () {
          if (!orderCreator.isClientNull) {
            RouteHandler.goEditAddressPage(context, id: orderCreator?.clientId)
                .then((value) {
              orderCreator.targetClient = value;
              // ignore: unnecessary_statements
              mounted ? setState(() {}) : '';
            });
            return;
          }
          return ToastKit.showInfo('请先添加客户哦');
        },
        child: Container(
          color: themeData.primaryColor,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 24,
                child: Text(
                  '收',
                  style: accentTextTheme.headline6
                      .copyWith(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                backgroundColor: themeData.accentColor,
              ),
              Expanded(
                  child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '收货人: ${client?.clientName ?? ''}',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text(
                            '${client?.tel ?? ''}',
                            style: TextStyle(
                                color: Color(0xFF6D6D6D), fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        '收货地址:${client?.address ?? ''}',
                        style:
                            TextStyle(fontSize: 13, color: Color(0xFF6D6D6D)),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              )),
              Container(
                child: Icon(ZYIcon.next),
              ),
            ],
          ),
        ));
  }
}
