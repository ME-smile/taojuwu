import 'package:flutter/material.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/zy_assetImage.dart';

class UserAddButton extends StatelessWidget {
  const UserAddButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          RouteHandler.goCustomerEditPage(context, title: '添加客户');
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
          child: ZYAssetImage(
            'client_add@2x.png',
            width: 24,
            height: 24,
          ),
        ));
  }
}
