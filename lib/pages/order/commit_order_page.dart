import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/constants/constants.dart';
import 'package:taojuwu/models/order/order_cart_goods_model.dart';
import 'package:taojuwu/pages/order/widgets/buyer_info_bar.dart';
import 'package:taojuwu/pages/order/widgets/seller_info_bar.dart';
import 'package:taojuwu/providers/order_provider.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/user_choose_button.dart';
import 'package:taojuwu/widgets/v_spacing.dart';
import 'package:taojuwu/widgets/zy_raised_button.dart';

import 'widgets/commit_order_card.dart';
import 'widgets/customer_need_bar.dart';

class CommitOrderPage extends StatefulWidget {
  final Map params;

  const CommitOrderPage({Key key, this.params}) : super(key: key);

  @override
  _CommitOrderPageState createState() => _CommitOrderPageState();
}

class _CommitOrderPageState extends State<CommitOrderPage> {
  ScrollController controller;
  Map params;
  List<OrderCartGoods> goodsList = [];
  @override
  void initState() {
    super.initState();

    controller = ScrollController();
    params = widget.params;
    if (params['data'] != null && params.isNotEmpty) {
      List list = params['data'];
      goodsList.addAll(list?.map((item) => OrderCartGoods.fromJson(item)));
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return Consumer<OrderProvider>(
      builder: (BuildContext context, OrderProvider provider, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('提交订单'),
            centerTitle: true,
            actions: <Widget>[UserChooseButton()],
          ),
          body: SingleChildScrollView(
            controller: controller,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                BuyerInfoBar(),
                VSpacing(20),
                SellerInfoBar(),
                VSpacing(20),
                Container(
                  child: ListView.separated(
                      controller: controller,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int i) {
                        return CommitOrderCard(
                          goods: goodsList[i],
                        );
                      },
                      separatorBuilder: (BuildContext context, int i) {
                        return Divider(
                          height: .5,
                          indent: UIKit.width(20),
                          endIndent: UIKit.width(20),
                        );
                      },
                      itemCount: goodsList?.length ?? 0),
                ),
                CustomerNeedBar(
                  isHideMeasureWindowNum: true,
                ),
                Consumer(
                    builder: (BuildContext context, OrderProvider provider, _) {
                  provider?.orderGoods = goodsList;
                  return Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: UIKit.width(20),
                        vertical: UIKit.height(20)),
                    alignment: Alignment.centerRight,
                    color: themeData.primaryColor,
                    width: double.infinity,
                    child: Text.rich(TextSpan(text: '小计:', children: [
                      TextSpan(text: '￥${provider?.totalPrice}\n'),
                      WidgetSpan(
                        child: Icon(
                          Icons.warning,
                          size: UIKit.sp(24),
                        ),
                      ),
                      TextSpan(text: '预估价格')
                    ])),
                  );
                }),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: UIKit.width(10)),
                  child: Text(
                    Constants.SERVER_PROMISE,
                    style: textTheme.caption,
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Consumer(
              builder: (BuildContext context, OrderProvider provider, _) {
            return Container(
              padding: EdgeInsets.symmetric(
                  vertical: UIKit.height(15), horizontal: UIKit.width(20)),
              decoration: BoxDecoration(
                  color: themeData.primaryColor,
                  border:
                      Border(top: BorderSide(color: Colors.grey, width: .3))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text.rich(TextSpan(
                      text: '共${provider?.totalCount}件\n',
                      style: textTheme.caption,
                      children: [
                        TextSpan(
                            text: '${provider?.totalPrice}',
                            style: textTheme.body1),
                        TextSpan(text: ' (具体金额以门店)', style: textTheme.caption)
                      ])),
                  ZYRaisedButton('提交订单', () {
                    provider?.createOrder(context);
                  }),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
