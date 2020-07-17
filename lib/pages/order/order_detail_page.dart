import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:taojuwu/constants/constants.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/models/order/order_detail_model.dart';
import 'package:taojuwu/pages/logistics/logistics_data_card.dart';
import 'package:taojuwu/pages/order/utils/order_kit.dart';
import 'package:taojuwu/pages/order/widgets/order_attr_card.dart';
import 'package:taojuwu/providers/order_detail_provider.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/singleton/target_order_goods.dart';

import 'package:taojuwu/singleton/target_client.dart';

import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/copy_button.dart';
import 'package:taojuwu/widgets/loading.dart';
import 'package:taojuwu/widgets/v_spacing.dart';
import 'package:taojuwu/widgets/zy_assetImage.dart';

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

    Future.delayed(Constants.TRANSITION_DURATION, () {
      fetchData();
    });
  }

  void fetchData() {
    OTPService.orderDetail(context, params: {'order_id': id})
        .then((OrderDerailModelResp response) {
      if (mounted) {
        setState(() {
          isLoading = false;
          OrderDetailModelWrppaer wrppaer = response?.data;
          model = wrppaer?.orderDetailModel;
          saveInfoForTargetClient(model);
        });
      }
    }).catchError((err) => err);
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isLoading = true;
  OrderDetailModel model;
  bool isShowDialog(String title) {
    return !['售后维权'].contains(title);
  }

  String getTimeStr(var milliSeconds) {
    var time = milliSeconds;
    if (time is num) {
      time = time * 1000;
    } else {
      time = 0;
    }
    return DateUtil.formatDateMs(time ?? 0,
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

  Widget buildTimeInfoBar(String title, String desc,
      {bool isActive: false, int type: 1}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: UIKit.height(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title),
          InkWell(
            onTap: isActive
                ? () {
                    RouteHandler.goOrderEditLogPage(context, id, type);
                  }
                : null,
            child: Container(
              child: Row(
                children: <Widget>[
                  Text(
                    desc,
                    style: TextStyle(color: Color(0xFF6D6D6D)),
                  ),
                  Offstage(
                    offstage: !isActive,
                    child: Icon(
                      ZYIcon.next,
                      size: UIKit.sp(32),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildinstallInfoTip(OrderDetailModel model) {
    return Column(
      children: <Widget>[
        buildTimeInfoBar(
            '量尺预约时间',
            model?.hasAdjustMeasureTime == true
                ? '${model?.measureTime ?? ''}(已调整)'
                : '${model?.measureTime}',
            isActive: model?.hasAdjustMeasureTime,
            type: 1),
        VSpacing(10),
        buildTimeInfoBar(
            '安装预约时间',
            model?.hasAdjustInstallime == true
                ? '${model?.installTime ?? ''}(已调整)'
                : '${model?.installTime}',
            isActive: model?.hasAdjustInstallime,
            type: 2),
      ],
    );
    // if (model?.isMeasureOrder == false) {
    //   return Column(
    //     children: <Widget>[
    //       Offstage(
    //         offstage: model?.hasMeasured == true,
    //         child:
    //             buildTimeInfoBar('上门量尺意向时间', model?.measureTime ?? ''),
    //       ),
    //       buildTimeInfoBar('客户意向安装时间', model?.installTime ?? ''),
    //       buildTimeInfoBar(
    //           '备注',
    //           model?.orderRemark == null || model?.orderRemark?.isEmpty == true
    //               ? '无'
    //               : model?.orderRemark)
    //     ],
    //   );
    // } else {
    //   if (model?.isShowAllInfo == true) {
    //     return Column(
    //       children: <Widget>[
    //         Offstage(
    //           offstage: model?.hasMeasured == true,
    //           child:
    //               buildTimeInfoBar('上门量尺意向时间', model?.measureTime ?? ''),
    //         ),
    //         buildTimeInfoBar('客户意向安装时���', model?.installTime ?? ''),
    //         buildTimeInfoBar('需��量窗数', '${model?.windowNum ?? 0}��'),
    //         buildTimeInfoBar('定金', '��������������������������������������������������������������${model?.orderEarnestMoney ?? 0}'),
    //         buildTimeInfoBar(
    //             '备注',
    //             model?.orderRemark == null ||
    //                     model?.orderRemark?.isEmpty == true
    //                 ? '无'
    //                 : model?.orderRemark),
    //       ],
    //     );
    //   }
    //   return Column(children: <Widget>[
    //     buildTimeInfoBar('客户意向安装时间', model?.installTime ?? ''),
    //     buildTimeInfoBar(
    //         '备注',
    //         model?.orderRemark == null || model?.orderRemark?.isEmpty == true
    //             ? '无'
    //             : model?.orderRemark),
    //   ]);
    // }
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
          Gallery(
            imgList: model?.measureManuscriptsPicture
                ?.map((item) => item?.toString())
                ?.toList(),
          ),
        ],
      ),
    );
  }

  Widget buildOriginPriceNote(BuildContext context,
      OrderDetailProvider provider, OrderDetailModel model) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: UIKit.height(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '原价:',
            style: leadingTextStyle,
          ),
          Text('¥${model?.orderEstimatedPrice ?? 0.00}',
              style: traillingTextStyle)
        ],
      ),
    );
  }

  Widget buildDepositPriceNote(BuildContext context,
      OrderDetailProvider provider, OrderDetailModel model) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: UIKit.height(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '定金:',
            style: leadingTextStyle,
          ),
          Text('¥${model?.orderEarnestMoney ?? 0.00}',
              style: traillingTextStyle)
        ],
      ),
    );
  }

  Widget buildTailPriceNote(BuildContext context, OrderDetailProvider provider,
      OrderDetailModel model) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: UIKit.height(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '尾款:',
            style: leadingTextStyle,
          ),
          Text('¥${model?.tailMoney ?? 0.00}', style: traillingTextStyle)
        ],
      ),
    );
  }

  Widget buildTotalPriceNote(BuildContext context, OrderDetailProvider provider,
      OrderDetailModel model,
      {String title: '合计', TextStyle textStyle}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: UIKit.height(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '$title:',
            style: leadingTextStyle,
          ),
          Text('¥${model?.realityPayMoney ?? 0.00}',
              style: textStyle ?? emphasizeTextStyle)
        ],
      ),
    );
  }

  Widget buildEditPriceNote(
    BuildContext context,
    OrderDetailProvider provider,
    OrderDetailModel model,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: UIKit.height(10)),
      child: model?.isWaitingToPay == true
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '修改:',
                  style: leadingTextStyle,
                ),
                Text(
                    '¥${provider?.deltaPrice ?? 0.00}${provider?.changePriceRemark != '' ? "(" + provider?.changePriceRemark + ")" : ""}')
              ],
            )
          : Offstage(
              offstage: model?.hasModifyPrice == true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '修改:',
                    style: leadingTextStyle,
                  ),
                  Text(
                      '¥${model?.adjustMoney ?? 0.00}${model?.isAdjustPriceRemarkEmpty == true ? "(" + model?.adjustMoney + ")" : ""}')
                ],
              ),
            ),
    );
  }

  TextStyle get leadingTextStyle =>
      TextStyle(fontWeight: FontWeight.normal, fontSize: 14);

  TextStyle get traillingTextStyle =>
      TextStyle(fontWeight: FontWeight.w500, fontSize: 14);

  TextStyle get titleTextStyle =>
      TextStyle(fontWeight: FontWeight.w500, fontSize: 14);

  TextStyle get emphasizeTextStyle => TextStyle(
      color: Color(0xFFFC5252), fontSize: 18, fontWeight: FontWeight.w500);

  Widget buildOrderFootNote(BuildContext context, OrderDetailProvider provider,
      OrderDetailModel model) {
    // if (provider?.isMeasureOrder == true) {
    //   return Container(
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: <Widget>[
    //         Text('定金:'),
    //         Text(
    //           '¥${model?.orderEarnestMoney ?? 0.00}',
    //           style: TextStyle(
    //               color: const Color(0xFFDE6D6C),
    //               fontSize: UIKit.sp(32),
    //               fontWeight: FontWeight.w600),
    //         )
    //       ],
    //     ),
    //   );
    // }

    if (model?.hasFinished == true || model?.isWaitingToInstall == true) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            buildDepositPriceNote(context, provider, model),
            buildTailPriceNote(context, provider, model),
            buildTotalPriceNote(context, provider, model, title: '预估总价'),
          ],
        ),
      );
    }

    if (model?.isWaitingToShipOrReceive == true ||
        model?.isProducting == true) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            buildDepositPriceNote(context, provider, model),
            Offstage(
              offstage: model?.hasModifyPrice == true,
              child: buildOriginPriceNote(context, provider, model),
            ),
            buildEditPriceNote(context, provider, model),
            buildTailPriceNote(context, provider, model),
            buildTotalPriceNote(
              context,
              provider,
              model,
            ),
          ],
        ),
      );
    }
    if (model?.isWaitingToPay == true) {
      return Consumer(
          builder: (BuildContext context, OrderDetailProvider provider, _) {
        return Container(
          child: Column(
            children: <Widget>[
              buildDepositPriceNote(context, provider, model),
              Offstage(
                offstage: provider?.hasEditPrice == false,
                child: buildOriginPriceNote(context, provider, model),
              ),
              Offstage(
                offstage: provider?.hasEditPrice == false,
                child: buildEditPriceNote(context, provider, model),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: UIKit.height(5)),
                child: buildTotalPriceNote(context, provider, model,
                    textStyle: traillingTextStyle),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: UIKit.height(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '尾款:',
                      style: leadingTextStyle,
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Text(
                            '¥${provider?.afterChangeTailMoney?.toStringAsFixed(2) ?? 0.00}',
                            style: emphasizeTextStyle,
                          ),
                          Offstage(
                            offstage: model?.canEditPrice == false,
                            child: InkWell(
                              onTap: () {
                                provider?.editPrict(context);
                              },
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(right: 2, left: 5),
                                    child: Text(
                                      '修改',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  Icon(
                                    ZYIcon.next,
                                    size: 12,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      });
    }

    if (model?.isMeasureOrder == true) {
      if (model?.hasAudited == false) {
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[buildDepositPriceNote(context, provider, model)],
          ),
        );
      }
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            buildDepositPriceNote(context, provider, model),
            buildTailPriceNote(context, provider, model),
            buildTotalPriceNote(context, provider, model, title: '预估价格'),
          ],
        ),
      );
    }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          buildDepositPriceNote(context, provider, model),
          buildTailPriceNote(context, provider, model),
          buildTotalPriceNote(context, provider, model, title: '预估价格'),
        ],
      ),
    );
  }

  Widget buildOrderInfoBar(BuildContext context, String title, String text,
      {bool showCopyButton: false}) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: UIKit.height(5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '$title:',
              style:
                  TextStyle(fontSize: UIKit.sp(28), color: Color(0xFF333333)),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Offstage(
                    offstage: !showCopyButton,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                      child: CopyButton(text),
                    ),
                  ),
                  Text(
                    '$text',
                    style: TextStyle(
                        fontSize: UIKit.sp(28), color: Color(0xFF333333)),
                  )
                ],
              ),
            )
          ],
        ));
  }

  Widget _orderGoodsDetail(
    BuildContext context,
    OrderDetailModel model,
  ) {
    ThemeData themeData = Theme.of(context);
    // TextTheme textTheme = themeData.textTheme;
    return Consumer<OrderDetailProvider>(
      builder: (BuildContext context, OrderDetailProvider provider, _) {
        return Container(
          padding: EdgeInsets.symmetric(
              horizontal: UIKit.width(20), vertical: UIKit.height(20)),
          color: themeData.primaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              InkWell(
                onTap: () {
                  RouteHandler.goOrderMainfestPage(context, model?.orderId);
                },
                child: ListBody(
                  children:
                      List.generate(model?.orderGoods?.length ?? 0, (int i) {
                    return OrderAttrCard(
                      goods: model?.orderGoods[i],
                      model: model,
                    );
                  }),
                ),
              ),
              Divider(),
              buildOrderFootNote(context, provider, model),
              Offstage(
                offstage: model?.isMeasureOrder == true &&
                    model?.hasMeasured == false,
                child: InkWell(
                  child: Container(
                    padding: EdgeInsets.only(top: UIKit.height(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          '${model?.goodsNumDescText},',
                          style: TextStyle(
                              color: Color(0xFF999999), fontSize: UIKit.sp(24)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 2),
                          child: Text(
                            '查看商品清单',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        Icon(
                          ZYIcon.next,
                          size: UIKit.sp(24),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    RouteHandler.goOrderMainfestPage(context, model?.orderId);
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  void deactivate() {
    super.deactivate();
    if (mounted) {
      fetchData();
    }
  }

  void saveInfoForTargetClient(OrderDetailModel model) {
    TargetClient targetClient = TargetClient();
    targetClient.setClientId(model?.clientId);
    targetClient.setClientName(model?.clientName);
    TargetOrderGoods.instance.orderId = model?.orderId;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    TextTheme accentTextTheme = themeData.accentTextTheme;
    TextTheme textTheme = themeData.textTheme;
    return isLoading
        ? LoadingCircle()
        : ChangeNotifierProvider<OrderDetailProvider>(
            create: (_) => OrderDetailProvider(
              model: model,
            ),
            child: WillPopScope(
                child: Scaffold(
                  appBar: AppBar(
                    title: Text('订单详情'),
                    centerTitle: true,
                    // actions: <Widget>[
                    //   FlatButton(
                    //       onPressed: () {
                    //         RouteHandler.goLogisticsPage(context, id);
                    //       },
                    //       child: Text('物流'))
                    // ],
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          padding:
                              EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                          height: UIKit.height(200),
                          color: Color(0xFF18181A),
                          child: Text.rich(TextSpan(
                              text:
                                  '${Constants.ORDER_STATUS_TIP_MAP[model?.orderStatus ?? 0]['title']}\n\n',
                              style: accentTextTheme.title.copyWith(
                                  fontSize: UIKit.sp(28),
                                  fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                  text: Constants.ORDER_STATUS_TIP_MAP[
                                      model?.orderStatus ?? 0]['subtitle'],
                                  style: accentTextTheme.body1
                                      .copyWith(color: Colors.white),
                                ),
                                TextSpan(
                                  text: model?.isWaitingToInstall == true
                                      ? model?.installTime ?? ''
                                      : '',
                                  style: accentTextTheme.body1
                                      .copyWith(color: Colors.white),
                                ),
                                TextSpan(
                                    text: model?.autoSignTime,
                                    style: accentTextTheme.body1
                                        .copyWith(color: Color(0xFFD7D7D7))),
                              ])),
                        ),
                        Offstage(
                          offstage: model?.displayDeliveryInfo == false,
                          child: InkWell(
                            onTap: () {
                              RouteHandler.goLogisticsPage(context, id);
                            },
                            child: Container(
                              color: themeData.primaryColor,
                              padding: EdgeInsets.symmetric(
                                  horizontal: UIKit.width(20),
                                  vertical: UIKit.height(24)),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        EdgeInsets.only(right: UIKit.width(20)),
                                    child: ZYAssetImage(
                                      'ship@2x.png',
                                    ),
                                  ),
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '${model?.acceptStation ?? ''}',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      VSpacing(10),
                                      Text(
                                        model?.acceptTime ?? '',
                                        style: textTheme.caption,
                                      ),
                                    ],
                                  )),
                                  Container(
                                    child: Icon(ZYIcon.next),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          indent: UIKit.width(20),
                          endIndent: UIKit.width(20),
                          thickness: .5,
                          height: .5,
                        ),
                        Container(
                          color: themeData.primaryColor,
                          padding: EdgeInsets.symmetric(
                              horizontal: UIKit.width(20),
                              vertical: UIKit.height(20)),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding:
                                    EdgeInsets.only(right: UIKit.width(20)),
                                child: Icon(
                                  ZYIcon.add,
                                  color: const Color(0xFF171717),
                                ),
                              ),
                              Expanded(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                      '收货人: ${model?.clientName ?? ''}  ${model?.receiverMobile ?? ''}'),
                                  Padding(
                                    padding: EdgeInsets.only(top: 4),
                                    child: Text(
                                      model?.address ?? '',
                                      style: textTheme.caption,
                                      maxLines: 2,
                                    ),
                                  )
                                ],
                              )),
                            ],
                          ),
                        ),
                        Divider(
                          indent: UIKit.width(20),
                          endIndent: UIKit.width(20),
                          thickness: .5,
                          height: .5,
                        ),
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
                              Row(
                                children: <Widget>[
                                  Container(
                                    width: 2,
                                    height: 16,
                                    color: Colors.black,
                                    margin:
                                        EdgeInsets.only(right: UIKit.width(10)),
                                  ),
                                  Text(
                                    '订单信息',
                                    style: TextStyle(fontSize: UIKit.sp(32)),
                                  ),
                                ],
                              ),
                              VSpacing(20),
                              buildOrderInfoBar(
                                  context,
                                  '订单备注',
                                  model?.orderRemark?.isEmpty == true
                                      ? '无备注'
                                      : model?.orderRemark),
                              buildOrderInfoBar(
                                  context, '订单编号', model?.orderNo ?? '',
                                  showCopyButton: true),
                              buildOrderInfoBar(context, '创建时间',
                                  getTimeStr(model?.createTime)),
                              Offstage(
                                offstage: model?.hasMeasured == false,
                                child: buildOrderInfoBar(context, '测量时间',
                                    getTimeStr(model?.realityMeasureTime)),
                              ),
                              Offstage(
                                offstage: model?.hasFinished == false,
                                child: buildOrderInfoBar(context, '安装时间',
                                    getTimeStr(model?.realityInstallTime)),
                              ),
                              // Offstage(
                              //   offstage: model?.hasInstalled == false,
                              //   child: buildOrderInfoBar(context, '安装时间',
                              //       getTimeStr(model?.realityInstallTime)),
                              // ),
                              buildOrderInfoBar(
                                  context, '下单人', model?.userName ?? ''),
                              buildOrderInfoBar(
                                  context, '客户名', model?.clientName ?? ''),
                              buildOrderInfoBar(
                                  context, '下单门店', model?.shopName ?? ''),
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
                onWillPop: () async {
                  Navigator.of(context).pop();
                  TargetClient.instance.clear();
                  return false;
                }),
          );
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
