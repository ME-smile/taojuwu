import 'package:flutter/material.dart';
import 'package:taojuwu/models/order/order_mainfest_model.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/copy_button.dart';
import 'package:taojuwu/widgets/v_spacing.dart';
import 'package:taojuwu/widgets/zy_future_builder.dart';

class OrderMainfestPage extends StatelessWidget {
  final int orderId;
  const OrderMainfestPage(this.orderId, {Key key}) : super(key: key);

  Widget buildHeader(BuildContext context, OrderMainfestModel model) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return Container(
      color: themeData.primaryColor,
      padding: EdgeInsets.symmetric(
          horizontal: UIKit.width(20), vertical: UIKit.height(20)),
      margin: EdgeInsets.only(bottom: UIKit.height(20)),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '客户: ${model?.clientName ?? ''}',
            style: textTheme.title
                .copyWith(fontSize: UIKit.sp(32), fontWeight: FontWeight.w600),
          ),
          Row(
            children: <Widget>[
              Text('订单编号:${model?.orderNo ?? ''}',
                  style: textTheme.caption.copyWith(fontSize: UIKit.sp(26))),
              CopyButton(model?.orderNo ?? '')
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('商品清单'),
        centerTitle: true,
      ),
      body: ZYFutureBuilder(
          futureFunc: OTPService.mainfest,
          params: {'order_id': orderId},
          builder: (BuildContext context, OrderMainfestModelResp response) {
            OrderMainfestModel wrapper = response?.data;
            List<GoodsMainfest> checkList = wrapper?.checkList;
            return SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: UIKit.width(20), vertical: UIKit.height(20)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    buildHeader(context, wrapper),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (BuildContext context, int i) {
                        return VSpacing(20);
                      },
                      itemBuilder: (BuildContext context, int i) {
                        return GoodsMainfestCard(
                          mainfest: checkList[i],
                        );
                      },
                      itemCount: checkList?.length ?? 0,
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class GoodsMainfestCard extends StatelessWidget {
  final GoodsMainfest mainfest;
  const GoodsMainfestCard({Key key, this.mainfest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Container(
      color: themeData.primaryColor,
      child: Column(
        children: <Widget>[
          ListBody(
            children: List.generate(mainfest?.list?.length ?? 0, (int i) {
              GoodsMainfestAttr item = mainfest?.list[i];
              return buildAttrText(context, item);
            }),
          ),
          Divider(),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: UIKit.height(20), horizontal: UIKit.width(20)),
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${mainfest?.statusName ?? ''}',
                  style: TextStyle(
                      color: Color(0xFFFC5252),
                      fontSize: UIKit.sp(28),
                      fontWeight: FontWeight.w500),
                ),
                Text.rich(
                    TextSpan(text: '共${mainfest?.count ?? 0}件,小计：', children: [
                  TextSpan(
                    text: '￥${mainfest?.price ?? ''}',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, fontSize: UIKit.sp(32)),
                  )
                ]))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAttrText(BuildContext context, GoodsMainfestAttr attr) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: UIKit.width(20), vertical: UIKit.height(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '${attr?.goodsName ?? ''}',
                style: textTheme.title.copyWith(
                    fontSize: UIKit.sp(28), fontWeight: FontWeight.w500),
              ),
              Text(
                '￥${attr?.price ?? ''}',
                style: textTheme.title.copyWith(
                    fontSize: UIKit.sp(28), fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '${attr?.goodsPrice ?? '0.00'}',
                style: textTheme.caption.copyWith(fontSize: UIKit.sp(26)),
              ),
              Text(
                '用料：${attr?.material ?? '0.00'}',
                style: textTheme.caption.copyWith(fontSize: UIKit.sp(26)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
