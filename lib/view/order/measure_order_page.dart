/*
 * @Description: 下测量单
 * @Author: iamsmiling
 * @Date: 2020-09-25 12:47:45
 * @LastEditTime: 2020-11-17 10:36:13
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/constants/constants.dart';
import 'package:taojuwu/providers/user_provider.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/viewmodel/order/base/base_order_creator.dart';
import 'package:taojuwu/viewmodel/order/curtain/measure_curtain_order_creator.dart';
import 'package:taojuwu/viewmodel/order/order_creator.dart';

import 'package:taojuwu/widgets/user_choose_button.dart';
import 'package:taojuwu/widgets/zy_future_button.dart';

import 'widgets/order_buyer_card.dart';
import 'widgets/order_remark_card/measure_order_remark_card.dart';
import 'widgets/seller_info_bar.dart';

class MeasureOrderPage extends StatefulWidget {
  MeasureOrderPage({Key key}) : super(key: key);

  @override
  _MeasureOrderPageState createState() => _MeasureOrderPageState();
}

class _MeasureOrderPageState extends State<MeasureOrderPage> {
  OrderCreator orderCreator;

  @override
  void initState() {
    orderCreator = OrderCreator();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return ChangeNotifierProvider<BaseOrderCreator>(
      create: (BuildContext context) => MeasureCurtainOrderCreator(
          context, context.read<UserProvider>().userInfo.shopId),
      builder: (BuildContext context, _) {
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
                  // BuyerInfoBar(),
                  OrderBuyerCard(orderCreator),
                  Divider(
                    height: 1,
                    indent: UIKit.width(20),
                    endIndent: UIKit.width(20),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: SellerInfoBar(),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(bottom: 10),
                  //   child: CustomerNeedBar(),
                  // ),
                  MeasureOrderRemarkCard(orderCreator),
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
          bottomNavigationBar: Builder(builder: (BuildContext ctx) {
            return Container(
              width: double.infinity,
              height: 96,
              padding: EdgeInsets.only(right: 10),
              alignment: Alignment.bottomRight,
              child: ZYFutureButton(
                isActive: true,
                text: '提交订单',
                verticalPadding: 8,
                callback: () => orderCreator.createMeasureOrder(context),
              ),
            );
          }),
        );
      },
    );
  }
}
