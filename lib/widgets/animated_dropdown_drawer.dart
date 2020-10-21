/*
 * @Description: 
 * @Author: iamsmiling
 * @Date: 2020-09-25 12:47:45
 * @LastEditTime: 2020-10-12 09:59:39
 */
import 'package:flutter/material.dart';

class AniamatedDropdownDrawer extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Function closeCallback;
  final bool shouldPop;
  AniamatedDropdownDrawer({
    Key key,
    this.child,
    this.closeCallback,
    this.shouldPop = true,
    this.duration = const Duration(milliseconds: 375),
  }) : super(key: key);

  @override
  AniamatedDropdownDrawerState createState() => AniamatedDropdownDrawerState();
}

class AniamatedDropdownDrawerState extends State<AniamatedDropdownDrawer>
    with SingleTickerProviderStateMixin {
  Widget get child => widget.child;
  Duration get duration => widget.duration;
  Function get closeCallback => widget.closeCallback;
  bool get shouldPop => widget.shouldPop;

  Animation<double> sizeAnimation;
  AnimationController animationController;

  Size get size => MediaQuery.of(context).size;
  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 375),
        reverseDuration: Duration(milliseconds: 375),
        vsync: this);

    sizeAnimation = animationController?.drive(
        Tween(begin: 0.0, end: 1.0)?.chain(CurveTween(curve: Curves.ease)));
    animationController?.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  Future close() {
    if (closeCallback != null) closeCallback();
    return animationController?.reverse()?.then((value) {
      // if (shouldPop) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: close,
      child: Container(
        alignment: Alignment.topCenter,
        height: size.height,
        width: size.width,
        child: SizeTransition(
          sizeFactor: sizeAnimation,
          child: child,
        ),
      ),
    );
  }
}
