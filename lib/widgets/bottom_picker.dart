import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/utils/ui_kit.dart';

class BottomPicker extends StatelessWidget {
  final String title;
  final Function callback;
  const BottomPicker({
    Key key,
    this.title,
    this.callback,
    @required this.child,
  })  : assert(child != null),
        super(key: key);

  final Widget child;

  // static double _kPickerItemHeight = 32.0;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: CupertinoColors.systemBackground.resolveFrom(context),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(UIKit.sp(20)),
              topLeft: Radius.circular(UIKit.sp(20)))),
      height: UIKit.height(500),
      // padding: const EdgeInsets.only(top: 6.0),
      child: DefaultTextStyle(
        style: TextStyle(
          color: CupertinoColors.label.resolveFrom(context),
          fontSize: 22.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  height: UIKit.height(90),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: UIKit.height(30)),
                          child: Text(
                            '取消',
                            style: TextStyle(
                                color: const Color(0xFF6E7486),
                                fontSize: UIKit.sp(32)),
                          ),
                        ),
                      ),
                      Text(
                        title,
                        style: TextStyle(
                            color: const Color(0xFF3C3C3C),
                            fontSize: UIKit.sp(36)),
                      ),
                      GestureDetector(
                        onTap: () {
                          callback();
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: UIKit.width(30)),
                          child: Text(
                            '确定',
                            style: TextStyle(
                                color: const Color(0xFF2196f3),
                                fontSize: UIKit.sp(32)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(child: child)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
