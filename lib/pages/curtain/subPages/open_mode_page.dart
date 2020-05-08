import 'package:flutter/material.dart';

class OpenModePage extends StatefulWidget {
  OpenModePage({Key key}) : super(key: key);

  @override
  _OpenModePageState createState() => _OpenModePageState();
}

class _OpenModePageState extends State<OpenModePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('打开方式'),
        centerTitle: true,
      ),
    );
  }
}