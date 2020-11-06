/*
 * @Description: 下测量单
 * @Author: iamsmiling
 * @Date: 2020-09-25 12:47:45
 * @LastEditTime: 2020-10-09 17:31:09
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/constants/constants.dart';
import 'package:taojuwu/providers/order_provider.dart';
import 'package:taojuwu/singleton/target_client.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/view/order/widgets/submit_order_button.dart';
import 'package:taojuwu/viewmodel/order/curtain/measure_curtain_order_creator.dart';

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

    return ChangeNotifierProvider<OrderProvider>(
      create: (BuildContext context) => OrderProvider(context),
      child: WillPopScope(
          child: Scaffold(
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
                    Divider(
                      height: 1,
                      indent: UIKit.width(20),
                      endIndent: UIKit.width(20),
                    ),

                    // BuyerInfoBar(),
                    SellerInfoBar(),
                    VSpacing(20),
                    CustomerNeedBar(),
                    VSpacing(20),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: UIKit.width(20)),
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
              width: double.infinity,
              height: 96,
              padding: EdgeInsets.only(right: 10),
              alignment: Alignment.bottomRight,
              child: SubmitOrderButton(MeasureCurtainOrderCreator(context, 1)),
            ),
            // bottomNavigationBar: Consumer<OrderProvider>(
            //   builder: (BuildContext context, OrderProvider provider, _) {
            //     return Container(
            //       // alignment: Alignment.bottomRight,
            //       padding: EdgeInsets.symmetric(
            //           vertical: UIKit.height(10), horizontal: UIKit.width(20)),
            //       color: themeData.primaryColor,
            //       child: Row(
            //         children: <Widget>[
            //           Spacer(),
            //           FlatButton(
            //             color: themeData.accentColor,
            //             child: Text(
            //               '提交订单',
            //               style: accentTextTheme.button,
            //             ),
            //             onPressed: () {
            //               provider?.createMeasureOrder(context);
            //             },
            //           ),
            //         ],
            //       ),
            //     );
            //   },
            // ),
          ),
          onWillPop: () {
            TargetClient().clear();
            Navigator.of(context).pop();
            return Future.value(false);
          }),
    );
  }
}
