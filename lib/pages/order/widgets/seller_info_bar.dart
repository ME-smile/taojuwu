import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/providers/user_provider.dart';
import 'package:taojuwu/utils/ui_kit.dart';

class SellerInfoBar extends StatelessWidget {
  const SellerInfoBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    TextTheme textTheme = themeData.textTheme;
    return Container(
      color: themeData.primaryColor,
      padding: EdgeInsets.symmetric(
          horizontal: UIKit.width(20), vertical: UIKit.height(20)),
      child: Row(
        children: <Widget>[
          // CircleAvatar(
          //   radius: UIKit.sp(60),
          //   child: Text(
          //     '售',
          //     style: accentTextTheme.title.copyWith(fontSize: UIKit.sp(36)),
          //   ),
          //   backgroundColor: themeData.accentColor,
          // ),
          Container(
            alignment: Alignment.center,
            child: Text(
              '售',
              style: textTheme.headline6
                  .copyWith(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            width: UIKit.sp(120),
            height: UIKit.sp(120),
            decoration: BoxDecoration(
              color: themeData.primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(UIKit.sp(60))),
              border: Border.all(
                color: themeData.accentColor,
              ),
            ),
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
                    Row(
                      children: [
                        Text(
                          '销售员: ${provider?.userInfo?.nickName ?? ''}',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: UIKit.width(32)),
                          child: Text(
                            '${provider?.userInfo?.userTel ?? ''}',
                            style: TextStyle(
                                color: Color(0xFF6D6D6D), fontSize: 13),
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        '门店地址:${provider?.userInfo?.shopName ?? ''}',
                        style:
                            TextStyle(fontSize: 13, color: Color(0xFF6D6D6D)),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                );
              },
            ),
          )),
          // Expanded(
          //     child: Container(
          //   padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
          //   alignment: Alignment.centerLeft,
          //   child: Consumer<UserProvider>(
          //     builder: (BuildContext context, UserProvider provider, _) {
          //       return Column(
          //         mainAxisAlignment: MainAxisAlignment.start,
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: <Widget>[
          //           Text('销售员: ${provider?.userInfo?.nickName ?? ''}'),
          //           Text('联系方式:${provider?.userInfo?.userTel ?? ''}'),
          //           Text('门店地址:${provider?.userInfo?.shopName ?? ''}'),
          //         ],
          //       );
          //     },
          //   ),
          // )),
        ],
      ),
    );
  }
}
