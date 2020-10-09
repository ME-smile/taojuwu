/*
 * @Description: //收货人信息
 * @Author: iamsmiling
 * @Date: 2020-09-25 12:47:45
 * @LastEditTime: 2020-10-09 17:52:15
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/viewmodel/order/base/base_order_creator.dart';

class BuyerInfoBar extends StatelessWidget {
  const BuyerInfoBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    TextTheme accentTextTheme = themeData.accentTextTheme;
    return Consumer<BaseOrderCreator>(
      builder: (BuildContext context, BaseOrderCreator orderCreator, _) {
        return GestureDetector(
            onTap: () {
              if (orderCreator.hasSelectedClient()) {
                RouteHandler.goEditAddressPage(context,
                    id: orderCreator?.clientId);
              }
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
                              '收货人: ${orderCreator?.clientName ?? ''}',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: UIKit.width(32)),
                              child: Text(
                                '${orderCreator?.tel ?? ''}',
                                style: TextStyle(
                                    color: Color(0xFF6D6D6D), fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            '收货地址:${orderCreator?.address ?? ''}',
                            style: TextStyle(
                                fontSize: 13, color: Color(0xFF6D6D6D)),
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
                ],
              ),
            ));
      },
    );
  }
}
