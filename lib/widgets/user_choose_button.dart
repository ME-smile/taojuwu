/*
 * @Description: 选择用户的按钮
 * @Author: iamsmiling
 * @Date: 2020-09-25 12:47:45
 * @LastEditTime: 2020-10-30 12:16:40
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:taojuwu/application.dart';
import 'package:taojuwu/event_bus/events/select_client_event.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/singleton/target_client.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/zy_assetImage.dart';

class UserChooseButton extends StatefulWidget {
  const UserChooseButton({Key key}) : super(key: key);

  @override
  _UserChooseButtonState createState() => _UserChooseButtonState();
}

class _UserChooseButtonState extends State<UserChooseButton> {
  StreamSubscription _streamSubscription;
  static TargetClient targetClient;
  @override
  void initState() {
    _streamSubscription =
        Application.eventBus.on<SelectClientEvent>().listen((event) {
      setState(() {
        targetClient = event.mTargetClient;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    targetClient = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          RouteHandler.goCustomerPage(context, isForSelectedClient: 1);
        },
        child: Row(
          children: <Widget>[
            ZYAssetImage(
              'client.png',
              width: 18,
              height: 18,
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                child: Text(
                  targetClient == null ? '请选择' : targetClient.displayName,
                  style: TextStyle(fontSize: 12),
                ))
          ],
        ));
  }
}
