import 'package:flutter/material.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/singleton/target_client.dart';
import 'package:taojuwu/utils/toast_kit.dart';
import 'package:taojuwu/utils/ui_kit.dart';

class BuyerInfoBar extends StatelessWidget {
  const BuyerInfoBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    TextTheme accentTextTheme = themeData.accentTextTheme;
    TargetClient targetClient = TargetClient();
    return InkWell(
        onTap: () {
          if (targetClient?.hasSelectedClient == false) {
            return ToastKit.showInfo('请先选择客户');
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
                radius: UIKit.sp(48),
                child: Text(
                  '收',
                  style: accentTextTheme.headline6
                      .copyWith(fontSize: 20, fontWeight: FontWeight.w500),
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
                  children: [
                    Row(
                      children: [
                        Text(
                          '收货人: ${targetClient?.clientName ?? ''}',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: UIKit.width(32)),
                          child: Text(
                            '${targetClient?.tel ?? ''}',
                            style: TextStyle(
                                color: Color(0xFF6D6D6D), fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        '收货地址:${targetClient?.address ?? ''}',
                        style:
                            TextStyle(fontSize: 13, color: Color(0xFF6D6D6D)),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              )),
              Container(
                child: Icon(ZYIcon.next),
              ),
              // Expanded(
              //     child: Container(
              //   padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
              //   alignment: Alignment.centerLeft,
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: <Widget>[
              //       Text('收货人:${targetClient?.clientName ?? ''}'),
              //       Text('联系方式:${targetClient?.tel ?? ''}'),
              //       Text(
              //         '收货地址:${targetClient?.address ?? ''}',

              //       ),
              //     ],
              //   ),
              // )),
              // Icon(ZYIcon.next)
            ],
          ),
        ));
  }
}
