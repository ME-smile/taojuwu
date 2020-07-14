import 'package:extended_image/extended_image.dart';
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
  const ZYNetImage(
      {Key key,
      this.imgPath,
      this.isCache: true,
      this.height,
      this.width,
      this.callback,
      this.fit: BoxFit.fill})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: callback,
        child: FadeInImage(
            width: width,
            height: height,
            fadeInDuration: Duration(milliseconds: 500),
            placeholder: AssetImage(UIKit.getAssetsImagePath(
              'goods_placeholder.png',
            )),
            image: ExtendedNetworkImageProvider(
                UIKit.getNetworkImgPath(imgPath),
                cache: true)));
  }
}
