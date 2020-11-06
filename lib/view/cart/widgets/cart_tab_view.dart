/*
 * @Description: 购物车tab视图
 * @Author: iamsmiling
 * @Date: 2020-11-06 09:33:06
 * @LastEditTime: 2020-11-06 09:51:04
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/services/otp_service.dart';

class CartTabView extends StatefulWidget {
  final int clientId;
  final String categoryId;
  CartTabView({Key key, this.categoryId, this.clientId}) : super(key: key);

  @override
  _CartTabViewState createState() => _CartTabViewState();
}

class _CartTabViewState extends State<CartTabView> {
  int get clientId => widget.clientId;
  String get categoryId => widget.categoryId;

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future fetchData() {
    return OTPService.cartList(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('购物车页面'),
    );
  }
}
