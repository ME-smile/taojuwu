import 'package:flutter/material.dart';

class OrderMainfestPage extends StatelessWidget {
  const OrderMainfestPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('商品清单'),
        centerTitle: true,
      ),
    );
  }
}
