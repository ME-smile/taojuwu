import 'package:flutter/material.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/v_spacing.dart';
import 'package:taojuwu/widgets/zy_assetImage.dart';

class Kongo extends StatelessWidget {
  final String text;
  final String iconPath;
  final Function callback;
  const Kongo({Key key, this.text, this.iconPath, this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Padding(
          padding: EdgeInsets.all(UIKit.width(10)),
          child: Column(
            children: <Widget>[
              ZYAssetImage(
                iconPath,
                width: UIKit.width(80),
                height: UIKit.height(50),
                callback: callback,
                // height: UIKit.height(80),
              ),
              VSpacing(10),
              Text(text,
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(fontSize: UIKit.sp(24)))
            ],
          )),
    );
  }
}
