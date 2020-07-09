import 'package:flutter/material.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/v_spacing.dart';
import 'package:taojuwu/widgets/zy_assetImage.dart';

class AnimationImage extends StatefulWidget {
  final String imgPath;
  final String text;
  AnimationImage(
    this.imgPath, {
    Key key,
    this.text: '什么也没有呢～',
  }) : super(key: key);

  @override
  _AnimationImageState createState() => _AnimationImageState();
}

class _AnimationImageState extends State<AnimationImage>
    with SingleTickerProviderStateMixin {
  AnimationController _logoController;
  Tween _scaleTween;
  CurvedAnimation _logoAnimation;

  @override
  void initState() {
    super.initState();

    _scaleTween = Tween(begin: 0, end: 1);
    _logoController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300))
          ..drive(_scaleTween);
    // Future.delayed(Duration(milliseconds: 500), () {
    //   _logoController?.forward();
    // });
    _logoController?.forward();
    _logoAnimation =
        CurvedAnimation(parent: _logoController, curve: Curves.bounceOut);
  }

  @override
  void dispose() {
    super.dispose();
    if (mounted) _logoController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: ScaleTransition(
        scale: _logoAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            ZYAssetImage(
              widget.imgPath,
              width: UIKit.width(250),
              height: UIKit.width(250),
            ),
            VSpacing(20),
            Text(
              widget.text,
              style: TextStyle(fontSize: UIKit.sp(28), color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}
