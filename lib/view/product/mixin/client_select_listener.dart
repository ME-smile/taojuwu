/*
 * @Description:客户选择监听
 * @Author: iamsmiling
 * @Date: 2020-10-29 10:36:12
 * @LastEditTime: 2020-10-29 16:44:22
 */
import 'dart:async';

import 'package:taojuwu/application.dart';
import 'package:taojuwu/event_bus/events/select_client_event.dart';
import 'package:taojuwu/singleton/target_client.dart';

abstract class TargetClientHolder {
  ///使用静态字段确保运行时 只存在一个clientId
  static TargetClient targetClient;
  StreamSubscription streamSubscription;

  TargetClient get client => targetClient;

  // ignore: unnecessary_getters_setters
  set client(TargetClient client);

  void addListener() {
    streamSubscription =
        Application.eventBus.on<SelectClientEvent>().listen((event) {
      client = event.mTargetClient;
    });
  }

  void relase() {
    streamSubscription?.cancel();
    streamSubscription = null;
  }
}
