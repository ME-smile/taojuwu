/*
 * @Description: 缩略图 
 * @Author: iamsmiling
 * @Date: 2020-10-13 09:29:46
 * @LastEditTime: 2020-11-04 10:54:02
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';

class ThumbnailCard extends StatelessWidget {
  final String url;
  const ThumbnailCard(this.url, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          boxShadow: [
            BoxShadow(
                offset: Offset(-.5, -.5), color: Colors.black.withAlpha(50)),
            BoxShadow(offset: Offset(.5, .5), color: Colors.black.withAlpha(50))
          ]),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: ZYNetImage(
          imgPath: url,
        ),
      ),
    );
  }
}
