import 'package:flutter/material.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/singleton/target_client.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/utils/ui_kit.dart';

class BuyerInfoBar extends StatelessWidget {
  const BuyerInfoBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    TextTheme accentTextTheme = themeData.accentTextTheme;
    TargetClient targetClient = TargetClient.instance;
    return InkWell(
        onTap: () {
          if (targetClient?.hasSelectedClient == false) {
            return CommonKit.showInfo('请先选择客户');
          }
          RouteHandler.goEditAddressPage(context, id: targetClient?.clientId);
        },
        child: Container(
          color: themeData.primaryColor,
          padding: EdgeInsets.symmetric(
              horizontal: UIKit.width(20), vertical: UIKit.height(20)),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: UIKit.sp(60),
                child: Text(
                  '收',
                  style: accentTextTheme.title.copyWith(fontSize: UIKit.sp(36)),
                ),
                backgroundColor: themeData.accentColor,
              ),
              Expanded(
                  child: Container(
                padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('收货人:${targetClient?.clientName ?? ''}'),
                    Text('联系方式:${targetClient?.tel ?? ''}'),
                    Text(
                      '收货地址:${targetClient?.address ?? ''}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )),
              Icon(ZYIcon.next)
            ],
          ),
        ));
  }
}
