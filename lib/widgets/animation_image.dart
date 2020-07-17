import 'package:flutter/material.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/v_spacing.dart';
import 'package:taojuwu/widgets/zy_assetImage.dart';

class AnimationImage extends StatelessWidget {
  final String imgPath;
  final String text;
  AnimationImage(
    this.imgPath, {
    Key key,
    this.text: '什么也没有呢～',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: TweenAnimationBuilder(
        curve: Curves.bounceInOut,
        tween: Tween<double>(begin: 0, end: UIKit.width(250)),
        duration: const Duration(milliseconds: 300),
        builder: (BuildContext context, double value, Widget child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              ZYAssetImage(
                imgPath,
                width: value,
                height: value,
              ),
              VSpacing(20),
              Text(
                text,
                style: TextStyle(fontSize: UIKit.sp(28), color: Colors.grey),
              )
            ],
          );
        },
      ),
    );
  }
}
