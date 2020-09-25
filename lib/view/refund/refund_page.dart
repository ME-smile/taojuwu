import 'package:flutter/material.dart';
import 'package:taojuwu/widgets/no_data.dart';

class RefundPage extends StatefulWidget {
  final int id;
  RefundPage({Key key, this.id}) : super(key: key);

  @override
  _RefundPageState createState() => _RefundPageState();
}

class _RefundPageState extends State<RefundPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('退单/售后'),
        centerTitle: true,
      ),
      body: NoData(),
    );
  }
}
