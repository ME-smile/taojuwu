import 'package:flutter/material.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/singleton/target_client.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/zy_assetImage.dart';

class UserChooseButton extends StatelessWidget {
  final int id;
  const UserChooseButton({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TargetClient targetClient = TargetClient.instance;

    return InkWell(
        onTap: () {
          RouteHandler.goCustomerPage(context, isForSelectedClient: 1);
        },
        child: Row(
          children: <Widget>[
            ZYAssetImage(
              'client.png',
              width: 18,
              height: 18,
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                child: Text(
                  targetClient?.hasSelectedClient == true
                      ? targetClient?.clientName ?? ''
                      : '请选择',
                  style: TextStyle(fontSize: 12),
                ))
          ],
        ));
  }
}
