/*
 * @Description: 缩略图 
 * @Author: iamsmiling
 * @Date: 2020-10-13 09:29:46
 * @LastEditTime: 2020-10-16 13:30:50
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';

class ThumbnailCard extends StatelessWidget {
  final String url;
  const ThumbnailCard(this.url, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(50))]),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: ZYNetImage(
          imgPath: url,
        ),
      ),
    );
  }
}
