import 'package:flutter/material.dart';
import 'package:taojuwu/icon/ZYIcon.dart';

class LikeButton extends StatefulWidget {
  final Function callback;
  final double size;
  final Color color;
  final bool hasLike;
  LikeButton({Key key, this.callback, this.color, this.size, this.hasLike})
      : super(key: key);

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation sizeAnimation;
  Animation colorAnimation;
  Animation curve;
  Color get color => widget.color;
  Function get callback => widget.callback;
  double get size => widget.size;
  bool get hasLiked => hasLiked;
  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(microseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    sizeAnimation = Tween(begin: size, end: 18.0).animate(animationController);
    colorAnimation = hasLiked
        ? ColorTween(begin: Colors.red[900], end: color)
        : ColorTween(begin: color, end: Colors.red[900])
            .animate(animationController);
    curve = CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (animationController?.status == AnimationStatus.completed) {
          animationController?.reverse();
        } else {
          animationController?.forward();
        }
      },
      child: Icon(
        ZYIcon.like,
        size: sizeAnimation?.value,
        color: colorAnimation.value,
      ),
    );
  }
}
