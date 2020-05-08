import 'package:flutter/material.dart';
import 'package:taojuwu/utils/ui_kit.dart';

import 'zy_assetImage.dart';

class NoData extends StatelessWidget {
  const NoData({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: ZYAssetImage(
        'empty@2x.png',
        width: UIKit.width(240),
        height: UIKit.height(240),
      ),
    );
  }
}
