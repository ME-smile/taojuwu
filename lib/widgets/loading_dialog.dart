import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingDialog extends Dialog {
  LoadingDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: SizedBox(
          width: 120.0,
          height: 120.0,
          child: Container(
            decoration: ShapeDecoration(
              color: const Color.fromARGB(250, 100, 100, 100),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
            ),
            child: CupertinoActivityIndicator(),
          ),
        ),
      ),
    );
  }
}
