import 'package:flutter/material.dart';

import 'package:taojuwu/widgets/animation_image.dart';

class NoData extends StatefulWidget {
  final bool isFromSearch;
  NoData({Key key, this.isFromSearch: false}) : super(key: key);

  @override
  _NoDataState createState() => _NoDataState();
}

class _NoDataState extends State<NoData> {
  @override
  Widget build(BuildContext context) {
    return AnimationImage(
        widget.isFromSearch ? 'no_data@2x.png' : 'empty@2x.png',
        text: widget.isFromSearch ? '无搜索结果，换个关键词试试吧～' : '什么也没有呢～');
  }
}
