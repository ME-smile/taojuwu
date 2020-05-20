import 'package:flutter/material.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/utils/ui_kit.dart';

class SearchButton extends StatelessWidget {
  final int type;
  const SearchButton({Key key, this.type: 1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: UIKit.width(15)),
      child: IconButton(
          icon: Icon(
            ZYIcon.search,
            color: const Color(0xFF979797),
          ),
          onPressed: () {
            RouteHandler.goSearchPage(context, type);
          }),
    );
  }
}
