import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:taojuwu/constants/constants.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/models/order/order_detail_model.dart';
import 'package:taojuwu/pages/order/utils/order_kit.dart';
import 'package:taojuwu/pages/order/widgets/order_attr_card.dart';
import 'package:taojuwu/providers/order_detail_provider.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/v_spacing.dart';

import 'package:taojuwu/widgets/zy_future_builder.dart';
import 'package:taojuwu/widgets/zy_outline_button.dart';

class OrderDetailPage extends StatefulWidget {
  final int id;
  OrderDetailPage({Key key, this.id}) : super(key: key);

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  int id;

  @override
  void initState() {
    super.initState();
    id = widget.id;
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isShowDialog(String title) {
    return !['售后维权'].contains(title);
  }

  Map<String, Function> createFuncMap(BuildContext context) {
    return {
      '售后维权': () {
        RouteHandler.goAfterSaleServicePage(context);
      },
      '提醒审核': () {
        OrderKit.remindOrder(context, '是否提醒审核', id, 1);
      },
      '提醒测量': () {
        OrderKit.remindOrder(context, '是否提醒测量', id, 2);
      },
      '提醒安装': () {},
      '去选品': () {},
      '': () {}
    };
  }

  Map<int, Widget> createBottomActionMap(
      BuildContext context, OrderDetailProvider provider) {
    return {
      0: Container(),
      15: Container(),
      1: Container(
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            buildCancelOrderButton(context)
            // buildRemindButton(context, '提醒审核', '是否提醒审核', 1),
          ],
        ),
      ),
      2: Container(
        color: Theme.of(context).primaryColor,
        child: Consumer<OrderDetailProvider>(
          builder: (BuildContext context,
              OrderDetailProvider orderDetailProvider, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ZYOutlineButton(
                  '取消订单0000',
                  () {
                    OrderKit.cancelOrder(
                      context,
                      id,
                    );
                  },
                  isActive: orderDetailProvider?.canCancelOrder,
                ),

                // buildRemindButton(context, '提醒测量', '是否提醒测量', 2),
              ],
            );
          },
        ),
      ),
      3: Container(
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            buildCancelOrderButton(context)
            // buildRemindButton(context, '提醒测量', '是否提醒测量', 2),
          ],
        ),
      ),
      6: Container(
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            buildRemindButton(context, '提醒安装', '是否提醒安装', -1),
            // buildCommonButton(context, '提醒安装', createFuncMap(context)['提醒安装']())
            // buildRemindButton(context, '提醒测量', '是否提醒测量', 2),
          ],
        ),
      ),
      8: Container(
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            buildRemindButton(context, '提醒安装', '是否提醒安装', -1),
            // buildRemindButton(context, '提醒测量', '是否提醒测量', 2),
          ],
        ),
      ),
      14: Container(
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            buildCancelOrderButton(context),
            buildButton(
              context,
              '确定',
              () {
                OrderKit.confirmToSelect(context, {'order_id': id});
              },
            ),
            // buildRemindButton(context, '提醒测量', '是否提醒测量', 2),
          ],
        ),
      ),
    };
  }

  String getcreateTimeStr(OrderDetailModel model) {
    var createTime = model?.createTime;
    if (createTime is num) {
      createTime = createTime * 1000;
    } else {
      createTime = 0;
    }
    return DateUtil.formatDateMs(createTime ?? 0,
            isUtc: false, format: 'yyyy-MM-dd HH:mm:ss') ??
        '';
  }

  Widget buildCancelOrderButton(BuildContext context) {
    return Consumer<OrderDetailProvider>(
      builder:
          (BuildContext context, OrderDetailProvider orderDetailProvider, _) {
        return ZYOutlineButton(
          '取消订单',
          () {
            OrderKit.cancelOrder(
              context,
              id,
            );
          },
          isActive: orderDetailProvider?.canCancelOrder,
        );
      },
    );
  }

  Widget buildCommonButton(
    BuildContext context,
    String buttonText,
    Function callback,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
      child: OutlineButton(
        onPressed: () {
          // OrderKit.remindOrder(context, title, id, status);
          createFuncMap(context)[buttonText ?? '']();
        },
        child: Text(
          buttonText,
        ),
      ),
    );
  }

  Widget buildAfterSaleServiceButton(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    // TextTheme textTheme = themeData.textTheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
      child: FlatButton(
        onPressed: () {
          // OrderKit.remindOrder(context, title, id, status);
        },
        color: themeData.accentColor,
        child: Text(
          '售后维权',
          style: themeData.accentTextTheme.button,
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context, String title, Function callback,
      {bool isActive: true}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
      child: OutlineButton(
        onPressed: isActive ? callback : null,
        child: Text(title),
      ),
    );
  }

  bool canEditPrice(OrderDetailModel model) {
    return model?.orderStatus == 3 ?? false;
  }

  Widget buildRemindButton(
      BuildContext context, String buttonText, String title, int status) {
    ThemeData themeData = Theme.of(context);
    // TextTheme textTheme = themeData.textTheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
      child: FlatButton(
        onPressed: () {
          OrderKit.remindOrder(context, title, id, status);
        },
        color: themeData.accentColor,
        child: Text(
          buttonText,
          style: themeData.accentTextTheme.button,
        ),
      ),
    );
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

  Widget buildinstallInfoTip(OrderDetailModel model) {
    if (model?.isMeasureOrder == false) {
      return Column(
        children: <Widget>[
          _customerRequirementBar('上门量尺意向时间', model?.measureTime ?? ''),
          _customerRequirementBar('客户意向安装时间', model?.installTime ?? ''),
          _customerRequirementBar(
              '备注',
              model?.orderRemark == null || model?.orderRemark?.isEmpty == true
                  ? '无'
                  : model?.orderRemark)
        ],
      );
    } else {
      if (model?.isShowAllInfo == true) {
        return Column(
          children: <Widget>[
            _customerRequirementBar('上门量尺意向时间', model?.measureTime ?? ''),
            _customerRequirementBar('客户意向安装时间', model?.installTime ?? ''),
            _customerRequirementBar('需测量窗数', '${model?.windowNum ?? 0}扇'),
            _customerRequirementBar('定金', '￥${model?.orderEarnestMoney ?? 0}'),
            _customerRequirementBar(
                '备注',
                model?.orderRemark == null ||
                        model?.orderRemark?.isEmpty == true
                    ? '无'
                    : model?.orderRemark),
          ],
        );
      }
      return Column(children: <Widget>[
        _customerRequirementBar('客户意向安装时间', model?.installTime ?? ''),
        _customerRequirementBar(
            '备注',
            model?.orderRemark == null || model?.orderRemark?.isEmpty == true
                ? '无'
                : model?.orderRemark),
      ]);
    }
  }

  Widget _measureManuscript(
    BuildContext context,
    OrderDetailModel model,
  ) {
    ThemeData themeData = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: UIKit.width(20), vertical: UIKit.height(20)),
      color: themeData.primaryColor,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('测量手稿'),
          Image.network(
            UIKit.getNetworkImgPath(model?.measureManuscriptsPicture?.first),
            width: UIKit.width(240),
          )
        ],
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

  Widget _orderGoodsDetail(
    BuildContext context,
    OrderDetailModel model,
  ) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return Consumer<OrderDetailProvider>(
      builder: (BuildContext context, OrderDetailProvider provider, _) {
        return Container(
          padding: EdgeInsets.symmetric(
              horizontal: UIKit.width(20), vertical: UIKit.height(20)),
          color: themeData.primaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              ListBody(
                children:
                    List.generate(model?.orderGoods?.length ?? 0, (int i) {
                  return OrderAttrCard(
                    goods: model?.orderGoods[i],
                    model: model,
                  );
                }),
              ),
              Divider(),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: UIKit.height(5)),
                  child: Text(
                      '${model?.isMeasureOrder == true ? '已付定金' : '定金'}:   ¥${model?.orderEarnestMoney}')),
              Offstage(
                offstage: model?.canEditPrice == false,
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: UIKit.height(5)),
                    child: Text('原价: ¥${provider?.afterChangeOriginPrice}')),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: UIKit.height(5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                          '合计:   ¥${double.parse(model?.orderEstimatedPrice ?? '0') + provider?.deltaPrice}'),
                      Offstage(
                        offstage: model?.canEditPrice == false,
                        child: InkWell(
                          onTap: () {
                            provider?.editPrict(context);
                          },
                          child: Row(
                            children: <Widget>[
                              Text('修改'),
                              Icon(
                                ZYIcon.edit,
                                size: 14,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
              provider.showDeltaPrice
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: UIKit.height(5)),
                      child: Text(
                          '修改: ¥${provider?.deltaPrice} ${provider?.hasRemark == true ? "(${provider?.changePriceRemark})" : ''}'))
                  : Container(),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: UIKit.height(5)),
                  child: Text.rich(TextSpan(
                      text: '尾款:',
                      style: textTheme.title.copyWith(fontSize: UIKit.sp(28)),
                      children: [
                        TextSpan(
                            text: '  ¥${provider?.afterChangeTailMoney}',
                            style: TextStyle(color: const Color(0xFFE02020)))
                      ]))),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme accentTextTheme = themeData.accentTextTheme;

    return ZYFutureBuilder(
        futureFunc: OTPService.orderDetail,
        params: {'order_id': id},
        builder: (BuildContext ctx, OrderDerailModelResp response) {
          OrderDetailModelWrppaer wrppaer = response?.data;
          OrderDetailModel model = wrppaer.orderDetailModel;
          return ChangeNotifierProvider<OrderDetailProvider>(
            create: (_) => OrderDetailProvider(model: model),
            child: Scaffold(
              appBar: AppBar(
                title: Text('订单详情'),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      padding:
                          EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                      height: UIKit.height(220),
                      color: themeData.accentColor,
                      child: Text.rich(TextSpan(
                          text:
                              '${Constants.ORDER_STATUS_TIP_MAP[model?.orderStatus ?? 0]['title']}\n\n',
                          style: accentTextTheme.title
                              .copyWith(fontSize: UIKit.sp(24)),
                          children: [
                            TextSpan(
                                text: Constants.ORDER_STATUS_TIP_MAP[
                                    model?.orderStatus ?? 0]['subtitle'],
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
                          Icon(
                            ZYIcon.add,
                            color: const Color(0xFF171717),
                          ),
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
                      child: buildinstallInfoTip(model),
                    ),
                    VSpacing(20),
                    _orderGoodsDetail(context, model),
                    VSpacing(20),
                    model?.isShowManuscript == true
                        ? _measureManuscript(context, model)
                        : Container(),
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
                          _orderInfoBar(
                              context, '创建时间', getcreateTimeStr(model)),
                          _orderInfoBar(context, '下单人', model?.userName ?? ''),
                          _orderInfoBar(
                              context, '客户名', model?.clientName ?? ''),
                          _orderInfoBar(context, '下单门店', model?.shopName ?? ''),
                        ],
                      ),
                    ),
                    VSpacing(50)
                  ],
                ),
              ),
              bottomNavigationBar: BottomActionButtonBar(
                orderId: id,
                orderStatus: model?.orderStatus ?? 0,
              ),
            ),
          );
        });
  }
}

class BottomActionButtonBar extends StatelessWidget {
  final int orderStatus;
  final int orderId;
  const BottomActionButtonBar({Key key, this.orderStatus, this.orderId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderDetailProvider>(
      builder: (BuildContext context, OrderDetailProvider provider, _) {
        print(orderStatus);
        return Offstage(
          offstage: provider?.showButton == false ?? false,
          child: Container(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: OrderKit.buildBottomActionButton(context, provider),
            ),
          ),
        );
      },
    );
  }
}

class SignSymbol extends StatefulWidget {
  final BuildContext ctx;
  SignSymbol(
    this.ctx, {
    Key key,
  }) : super(key: key);

  @override
  _SignSymbolState createState() => _SignSymbolState();
}

class _SignSymbolState extends State<SignSymbol> {
  OrderDetailProvider provider;
  @override
  void initState() {
    super.initState();
    provider = Provider.of<OrderDetailProvider>(widget.ctx);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    Color accentColor = themeData.accentColor;
    return Container(
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: () {
              setState(() {
                provider?.isMinus = true;
              });
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: UIKit.width(10)),
              child: provider?.isMinus == true
                  ? Icon(
                      ZYIcon.sub_full,
                      color: accentColor,
                    )
                  : Icon(
                      ZYIcon.sub_blank,
                    ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                provider?.isMinus = false;
              });
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: UIKit.width(10)),
              child: provider?.isMinus == true
                  ? Icon(ZYIcon.plus_blank)
                  : Icon(
                      ZYIcon.plus_full,
                      color: accentColor,
                    ),
            ),
          )
        ],
      ),
    );
  }
}

//http://buyi.taoju5.com admin tjw2023
