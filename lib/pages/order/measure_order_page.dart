import 'package:flutter/material.dart';
import 'package:taojuwu/constants/constants.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/user_choose_button.dart';
import 'package:taojuwu/widgets/v_spacing.dart';

import 'widgets/buyer_info_bar.dart';
import 'widgets/customer_need_bar.dart';
import 'widgets/seller_info_bar.dart';

class MeasureOrderPage extends StatefulWidget {
  MeasureOrderPage({Key key}) : super(key: key);

  @override
  _MeasureOrderPageState createState() => _MeasureOrderPageState();
}

class _MeasureOrderPageState extends State<MeasureOrderPage> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextTheme accentTextTheme = themeData.accentTextTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('下测量单'),
        centerTitle: true,
        actions: <Widget>[
          UserChooseButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              BuyerInfoBar(),
              VSpacing(20),
              // BuyerInfoBar(),
              SellerInfoBar(),
              CustomerNeedBar(),
              VSpacing(20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                child: Text(
                  Constants.SERVER_PROMISE,
                  style: textTheme.caption,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        // alignment: Alignment.bottomRight,
        padding: EdgeInsets.symmetric(
          vertical: UIKit.height(10),
          horizontal: UIKit.width(20)
        ),
        color: themeData.primaryColor,
        child: Row(
          children: <Widget>[
            Spacer(),
            FlatButton(
              color: themeData.accentColor,
              child: Text(
                '提交订单',
                style: accentTextTheme.button,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
