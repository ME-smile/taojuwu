/*
 * @Description: 填写收获地址操作模型
 * @Author: iamsmiling
 * @Date: 2020-10-10 15:48:37
 * @LastEditTime: 2020-10-10 16:03:57
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:taojuwu/application.dart';
import 'package:taojuwu/event_bus/events/select_client_event.dart';
import 'package:taojuwu/singleton/target_client.dart';

class EditAddressActionModel with ChangeNotifier {
  StreamSubscription _subscription;
  TargetClient client;
  EditAddressActionModel() {
    _subscription =
        Application.eventBus.on<SelectClientEvent>().listen((event) {
      client = event.mTargetClient;
      notifyListeners();
    });

    // _nameNontroller = TextEditingController(text: client?.clientName);
  }

  //选择性别
  void checkGender(int i) {
    client.gender = i;
    // notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
