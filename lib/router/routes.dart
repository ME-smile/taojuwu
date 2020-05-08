import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'handlers.dart';

class Routes {
  //routes
  static const String splashPage = '/splashPage';
  static const String home = '/home';
  static const String login = '/login';
  static const String curtain = '/curtain';
  static const String curtainDetail = '/curtain/detail';
  static const String customer = '/customer';
  static const String customerDetail = 'customer/detail';
  static const String customerEdit = '/customer/edit';
  static const String customerTable = '/customer/table';
  static const String order = '/order';
  static const String orderDetail = '/order/detail';
  static const String measureOrder = '/measureOrder';
  static const String setting = '/setting';
  static const String combo = '/combo';
  static const String dataCenter = '/dataCenter';
  static const String profile = '/profile';
  static const String curtainMall = '/curtainMall';
  static const String switchAccount = '/switchAccount';
  static const String feedback = '/feedback';
  static const String commitSuccess = '/commitSuccess';
  static const String editAddress = '/editAddress';
  static const String search = '/search';
  static const String preMeasureData = '/preMeasureData';
  static const String cart = '/cart';
  static const String commitOrder = '/commitOrder';
  static const String orderCommitSuccess = '/orderCommitSuccess';
  static const String orderSearch = '/orderSearch';
  static const String customerSearch = '/customerSearch';
  static void configureRoutes(Router router) {
    router.notFoundHandler = new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('开发中...'),
        ),
      );
    });
    router.define(home, handler: RouteHandler.home);
    router.define(login, handler: RouteHandler.login);
    router.define(curtain, handler: RouteHandler.curtain);
    router.define(customer, handler: RouteHandler.customer);
    router.define(order, handler: RouteHandler.order);
    router.define(setting, handler: RouteHandler.setting);
    router.define(combo, handler: RouteHandler.combo);
    router.define(dataCenter, handler: RouteHandler.dataCenter);
    router.define(profile, handler: RouteHandler.profile);
    router.define(curtainMall, handler: RouteHandler.curtainMall);
    router.define(customerDetail, handler: RouteHandler.customerDetail);
    router.define(customerEdit, handler: RouteHandler.customerEdit);
    router.define(customerTable, handler: RouteHandler.customerTable);
    router.define(curtainDetail, handler: RouteHandler.curtainDetail);
    router.define(measureOrder, handler: RouteHandler.measureOrder);
    router.define(switchAccount, handler: RouteHandler.switchAccount);
    router.define(feedback, handler: RouteHandler.feedback);
    router.define(commitSuccess, handler: RouteHandler.commitSuccess);
    router.define(editAddress, handler: RouteHandler.editAddress);
    router.define(search, handler: RouteHandler.search);
    router.define(preMeasureData, handler: RouteHandler.preMeasureData);
    router.define(orderDetail, handler: RouteHandler.orderDetail);
    router.define(cart, handler: RouteHandler.cart);
    router.define(commitOrder, handler: RouteHandler.commitOrder);
    router.define(orderCommitSuccess, handler: RouteHandler.orderCommitSuccess);
    router.define(orderSearch, handler: RouteHandler.orderSearch);
    router.define(customerSearch, handler: RouteHandler.customerSearch);
  }
}
