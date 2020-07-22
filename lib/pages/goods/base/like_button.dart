import 'package:flutter/material.dart';
import 'package:taojuwu/icon/ZYIcon.dart';

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
        child: Icon(ZYIcon.like,
            color: hasLiked ? Color(0xFFFF6161) : Color(0xFFCCCCCC)),
      ),
    );
  }
}
