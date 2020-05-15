import 'package:flutter/material.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/zy_assetImage.dart';

class AnimationImage extends StatefulWidget {
  final String imgPath;
  AnimationImage(
    this.imgPath, {
    Key key,
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
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..drive(_scaleTween);
    Future.delayed(Duration(milliseconds: 500), () {
      _logoController.forward();
    });
    _logoAnimation =
        CurvedAnimation(parent: _logoController, curve: Curves.easeOutQuart);
  }

  @override
  void dispose() {
    super.dispose();
    _logoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ScaleTransition(
        scale: _logoAnimation,
        child: ZYAssetImage(
          widget.imgPath,
          width: UIKit.width(120),
          height: UIKit.width(120),
        ),
      ),
    );
  }
}
