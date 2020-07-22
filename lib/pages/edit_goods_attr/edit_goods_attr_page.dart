import 'package:flutter/material.dart';

class EditGoodsAttrPage extends StatelessWidget {
  final int id;
  const EditGoodsAttrPage({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('修改属性'),
        centerTitle: true,
      ),
    );
  }
}
