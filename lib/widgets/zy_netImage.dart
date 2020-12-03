/*
 * @Description: 网络图片封装
 * @Author: iamsmiling
 * @Date: 2020-09-25 12:47:45
 * @LastEditTime: 2020-11-27 09:35:29
 */
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/utils/ui_kit.dart';
// import 'package:taojuwu/widgets/loading.dart';

class ZYNetImage extends StatelessWidget {
  final String imgPath;
  final bool isCache;
  final double width;
  final double height;
  final Function callback;
  final BoxFit fit;
  final bool needAnimation;
  const ZYNetImage(
      {Key key,
      this.imgPath,
      this.isCache: false,
      this.height,
      this.width,
      this.callback,
      this.needAnimation = true,
      this.fit: BoxFit.contain})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: CachedNetworkImage(
        imageUrl: UIKit.getNetworkImgPath(imgPath),
        width: width,
        height: height,
        fit: fit,
        fadeInDuration: Duration(milliseconds: 180),
        fadeOutDuration: Duration(milliseconds: 180),
        placeholder: (BuildContext context, _) {
          return Image.asset(
            UIKit.getAssetsImagePath(
              'placeholder_img.jpg',
            ),
            fit: fit,
          );
        },
        errorWidget: (BuildContext context, String name, _) {
          return Image.asset(
            UIKit.getAssetsImagePath(
              'placeholder_img.jpg',
            ),
            fit: fit,
          );
        },
      ),
    );
  }
}
