import 'package:flutter/material.dart';

class TargetRoute {
  TargetRoute._internal();
  static TargetRoute _instance = TargetRoute._internal();
  factory TargetRoute() {
    return _instance;
  }

  static TargetRoute get instance => _instance;
  String route;

  State state;
  bool flag = false;
  BuildContext context;
  void setRoute(String route) {
    _instance.route = route;
  }
}
