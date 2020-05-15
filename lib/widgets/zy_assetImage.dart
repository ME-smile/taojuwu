import 'package:flutter/material.dart';
import 'package:taojuwu/utils/ui_kit.dart';

class ZYAssetImage extends StatelessWidget {
  final Function callback;
  final String path;
  final double width;
  final double height;
  final BoxFit fit;
  const ZYAssetImage(this.path,
      {Key key, this.callback, this.width: 20, this.height: 20, this.fit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Image.asset(
        UIKit.getAssetsImagePath(path),
        width: width,
        height: height,
        fit: fit,
      ),
      onTap: callback ?? () {},
    );
  }
}
