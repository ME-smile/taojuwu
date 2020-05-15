import 'package:flutter/material.dart';

import 'package:taojuwu/widgets/animation_image.dart';

class NoData extends StatefulWidget {
  NoData({Key key}) : super(key: key);

  @override
  _NoDataState createState() => _NoDataState();
}

class _NoDataState extends State<NoData> {
  @override
  Widget build(BuildContext context) {
    return AnimationImage(
      'empty@2x.png',
    );
  }
}
