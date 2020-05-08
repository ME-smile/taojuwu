import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/providers/client_provider.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/utils/ui_kit.dart';

class UserChooseButton extends StatelessWidget {
  final int id;
  const UserChooseButton({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, ClientProvider provider, _) {
      return InkWell(
          onTap: () {
            provider?.isForSelectedClient = true;
            provider?.goodsId = id;
            RouteHandler.goCustomerPage(context);
          },
          child: Row(
            children: <Widget>[
              ZYIcon.user,
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                  child: Text(provider?.name??'请选择'))
            ],
          ));
    });
  }
}
