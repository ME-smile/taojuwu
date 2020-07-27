import 'package:flutter/material.dart';
import 'package:taojuwu/utils/ui_kit.dart';

class LikeButton extends StatefulWidget {
  final bool hasLiked;
  final Function callback;
  LikeButton({Key key, this.hasLiked = false, this.callback}) : super(key: key);

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  Function get callback => widget.callback;
  bool get hasLiked => widget.hasLiked;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
          child: Image.asset(
        UIKit.getAssetsImagePath(
          hasLiked ? 'heart_fill@2x.png' : 'heart_blank@2x.png',
        ),
        width: 25,
        height: 25,
      )),
    );
  }
}
