import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/providers/user_provider.dart';
import 'package:taojuwu/utils/ui_kit.dart';

class SellerInfoBar extends StatelessWidget {
  const SellerInfoBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    TextTheme accentTextTheme = themeData.accentTextTheme;
    return Container(
      color: themeData.primaryColor,
      padding: EdgeInsets.symmetric(
          horizontal: UIKit.width(20), vertical: UIKit.height(20)),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: UIKit.sp(60),
            child: Text(
              '售',
              style: accentTextTheme.title.copyWith(fontSize: UIKit.sp(36)),
            ),
            backgroundColor: themeData.accentColor,
          ),
          Expanded(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
            alignment: Alignment.centerLeft,
            child: Consumer<UserProvider>(
              builder: (BuildContext context, UserProvider provider, _) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('销售员: ${provider?.userInfo?.nickName ?? ''}'),
                    Text('联系方式:${provider?.userInfo?.userTel ?? ''}'),
                    Text('门店地址:${provider?.userInfo?.shopName ?? ''}'),
                  ],
                );
              },
            ),
          )),
          ZYIcon.next
        ],
      ),
    );
  }
}
