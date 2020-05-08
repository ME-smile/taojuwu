import 'package:flutter/material.dart';

class CustomerInfoBar extends StatelessWidget {
  final bool showBorder;
  final String title;
  final Widget trailing;
  const CustomerInfoBar(
      {Key key, this.title, this.showBorder: true, this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ThemeData themeData = Theme.of(context);
    // TextTheme textTheme = themeData.textTheme;
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '$title',
              ),
              trailing,
            ],
          ),
          showBorder ? Divider() : Container(),
        ],
      ),
    );
  }
}
