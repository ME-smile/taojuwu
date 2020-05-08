import 'package:flutter/material.dart';
import 'package:taojuwu/constants/constants.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/models/order/order_detail_model.dart';
import 'package:taojuwu/pages/order/widgets/order_attr_card.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/v_spacing.dart';
import 'package:taojuwu/widgets/zy_future_builder.dart';

class OrderDetailPage extends StatelessWidget {
  final int id;
  const OrderDetailPage(this.id, {Key key}) : super(key: key);
  bool showCancelButton(String status) {
    return Constants.SHOW_CANCEL_BUTTON_STATUS.contains(status);
  }

  Widget _customerRequirementBar(String title, String desc) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: UIKit.height(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[Text(title), Text(desc)],
      ),
    );
  }

  Widget _orderInfoBar(BuildContext context, String title, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: UIKit.height(5)),
      child: Text(
        '$title: $text',
        style: Theme.of(context).textTheme.caption,
      ),
    );
  }

  Widget _orderGoodsDetail(BuildContext context, OrderDetailModel model) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: UIKit.width(20), vertical: UIKit.height(20)),
      color: themeData.primaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          ListBody(
            children: List.generate(model?.orderGoods?.length ?? 0, (int i) {
              return OrderAttrCard(
                goods: model?.orderGoods[i],
              );
            }),
          ),
          VSpacing(10),
          Text.rich(TextSpan(
              text: '小计 ',
              style: textTheme.caption.copyWith(fontSize: UIKit.sp(20)),
              children: [
                TextSpan(
                    text: '¥${model?.realityPayMoney}',
                    style: textTheme.body1.copyWith(fontSize: UIKit.sp(24))),
              ])),
          Divider(),
          Padding(
              padding: EdgeInsets.symmetric(vertical: UIKit.height(5)),
              child: Text('定金:   ¥${model?.orderEarnestMoney}')),
          Padding(
              padding: EdgeInsets.symmetric(vertical: UIKit.height(5)),
              child: Text('合计:   ¥${model?.orderEstimatedPrice}')),
          Padding(
              padding: EdgeInsets.symmetric(vertical: UIKit.height(5)),
              child: Text.rich(TextSpan(
                  text: '尾款:',
                  style: textTheme.title.copyWith(fontSize: UIKit.sp(28)),
                  children: [
                    TextSpan(
                        text: '  ¥${model?.tailMoney}',
                        style: TextStyle(color: const Color(0xFFE02020)))
                  ]))),
          Padding(
            padding: EdgeInsets.symmetric(vertical: UIKit.height(5)),
            child: Text.rich(
              TextSpan(text: '', style: textTheme.caption, children: [
                WidgetSpan(
                  child: Icon(
                    Icons.warning,
                    size: UIKit.sp(24),
                  ),
                ),
                TextSpan(text: '预估价格', style: textTheme.caption)
              ]),
              textAlign: TextAlign.center,
            ),
            // Text('定金: ￥${wrapper?}')
          )
        ],
      ),
    );
  }

  static OrderDetailModel model;
  @override
  Widget build(BuildContext context) {
    print(id);
    ThemeData themeData = Theme.of(context);
    TextTheme accentTextTheme = themeData.accentTextTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('订单详情'),
        centerTitle: true,
      ),
      body: ZYFutureBuilder(
          futureFunc: OTPService.orderDetail,
          params: {'order_id': id},
          builder: (BuildContext context, OrderDerailModelResp response) {
            OrderDetailModelWrppaer wrppaer = response?.data;
            OrderDetailModel model = wrppaer.orderDetailModel;
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                    height: UIKit.height(220),
                    color: themeData.accentColor,
                    child: Text.rich(TextSpan(
                        text:
                            '${Constants.ORDER_STATUS_TIP_MAP[model?.statusName]['title']}\n\n',
                        style: accentTextTheme.title
                            .copyWith(fontSize: UIKit.sp(24)),
                        children: [
                          TextSpan(
                              text: Constants.ORDER_STATUS_TIP_MAP[
                                  model?.statusName ?? '']['subtitle'],
                              style: accentTextTheme.body1)
                        ])),
                  ),
                  Container(
                    color: themeData.primaryColor,
                    padding: EdgeInsets.symmetric(
                        horizontal: UIKit.width(20),
                        vertical: UIKit.height(20)),
                    child: Row(
                      children: <Widget>[
                        ZYIcon.add,
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                '收货人: ${model?.clientName ?? ''}  ${model?.receiverMobile ?? ''}'),
                            Text(model?.receiverAddress ?? '')
                          ],
                        ),
                      ],
                    ),
                  ),
                  VSpacing(20),
                  Container(
                    color: themeData.primaryColor,
                    padding: EdgeInsets.symmetric(
                        horizontal: UIKit.width(20),
                        vertical: UIKit.height(20)),
                    child: Column(
                      children: <Widget>[
                        _customerRequirementBar(
                            '上门量尺意向时间', model?.measureTime ?? ''),
                        _customerRequirementBar(
                            '客户意向安装时间', model?.installTime ?? ''),
                        _customerRequirementBar('备注', model?.orderRemark),
                      ],
                    ),
                  ),
                  VSpacing(20),
                  _orderGoodsDetail(context, model),
                  VSpacing(20),
                  Container(
                    color: themeData.primaryColor,
                    padding: EdgeInsets.symmetric(
                        horizontal: UIKit.width(20),
                        vertical: UIKit.height(20)),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '订单信息',
                        ),
                        _orderInfoBar(context, '订单编号', model?.orderNo ?? ''),
                        _orderInfoBar(context, '创建时间', model?.orderNo ?? ''),
                        _orderInfoBar(context, '下单人', model?.userName ?? ''),
                        _orderInfoBar(context, '客户名', model?.clientName ?? ''),
                        _orderInfoBar(context, '下单门店', model?.shopName ?? ''),
                      ],
                    ),
                  ),
                  VSpacing(50)
                ],
              ),
            );
          }),
      bottomNavigationBar: Container(
        color: themeData.primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Offstage(
              offstage: showCancelButton(model?.statusName),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                child: OutlineButton(
                  onPressed: () {},
                  child: Text('取消订单'),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
              child: FlatButton(
                onPressed: () {},
                color: themeData.accentColor,
                child: Text(
                  '提醒审核',
                  style: themeData.accentTextTheme.button,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//http://buyi.taoju5.com admin tjw2023
