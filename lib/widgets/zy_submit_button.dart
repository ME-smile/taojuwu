import 'package:flutter/material.dart';
import 'package:taojuwu/utils/ui_kit.dart';

class ZYSubmitButton extends StatelessWidget {
  final String text;
  final Function callback;
  const ZYSubmitButton(
    this.text,
    this.callback, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
          horizontal: UIKit.width(50), vertical: UIKit.height(20)),
      child: RaisedButton(
        onPressed: callback,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: UIKit.height(20)),
          child: Text(
            text ?? '',
            style: Theme.of(context).accentTextTheme.button,
          ),
        ),
      ),
    );
  }
}
