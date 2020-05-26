import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/models/order/order_model.dart';
import 'package:taojuwu/pages/order/utils/order_kit.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';

class MeasureOrderHasNotSelectedProductedCard extends StatelessWidget {
  final OrderModelData orderModelData;
  final int tab;
  const MeasureOrderHasNotSelectedProductedCard(
      {Key key, this.orderModelData, this.tab})
      : super(key: key);
  String get orderEarnestMoneyStr {
    var createTime = orderModelData?.createTime;
    if (createTime is num) {
      createTime = createTime * 1000;
    } else {
      createTime = 0;
    }
    return DateUtil.formatDateMs(createTime ?? 0,
            isUtc: false, format: 'yyyy-MM-dd HH:mm:ss') ??
        '';
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    final List<OrderModel> models = orderModelData?.models;
    return Container(
      color: themeData.primaryColor,
      padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ListBody(
            children: List.generate(models?.length ?? 0, (int i) {
              return MeasureOrderHasNotSelectedProductItemView(
                  orderModelData: orderModelData,
                  model: models[i],
                  id: orderModelData?.orderId);
            }),
          ),
          Row(children: <Widget>[
            Expanded(child: SizedBox()),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text('应收定金:${orderModelData?.orderEarnestMoneyStr ?? '0.00'}'),
                Text('创建时间:${orderEarnestMoneyStr ?? ''}',
                    style: textTheme.caption),
              ],
            )
          ]),
          OrderKit.buildButton(context, orderModelData, callback: () {
            RouteHandler.goOrderDetailPage(context, orderModelData?.orderId);
          })
        ],
      ),
    );
  }
}

class MeasureOrderHasSelectedProductCard extends StatelessWidget {
  final OrderModelData orderModelData;
  final int tab;
  const MeasureOrderHasSelectedProductCard(
      {Key key, this.orderModelData, this.tab})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    final List<OrderModel> models = orderModelData?.models;
    return Container(
      color: themeData.primaryColor,
      padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ListBody(
            children: List.generate(models?.length ?? 0, (int i) {
              return MeasureOrderHasSelectedProductItemView(
                  model: models[i], id: orderModelData?.orderId);
            }),
          ),
          Row(children: <Widget>[
            Expanded(child: SizedBox()),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text('客户:${orderModelData?.clientName ?? ''}'),
                Text('订单号:${orderModelData?.orderNo ?? ''}',
                    style: textTheme.caption),
                Text('测量时间:${orderModelData?.measureTime ?? ''}',
                    style: textTheme.caption),
                Text(
                    '共${orderModelData?.orderWindowNum ?? 1}窗,已选${orderModelData?.goodsCount}件商品 合计: ￥${orderModelData?.orderEstimatedPrice}',
                    style: textTheme.caption)
              ],
            )
          ]),
          OrderKit.buildButton(context, orderModelData, callback: () {
            RouteHandler.goOrderDetailPage(context, orderModelData?.orderId);
          })
        ],
      ),
    );
  }
}

class MeasureOrderHasSelectedProductItemView extends StatelessWidget {
  final OrderModel model;
  final int id;
  final int tab;
  const MeasureOrderHasSelectedProductItemView(
      {Key key, this.model, this.id, this.tab})
      : super(key: key);

  String get sizeText => '宽: ${model.width / 100}米 高: ${model.height / 100}米';

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return InkWell(
      onTap: () {
        RouteHandler.goOrderDetailPage(context, id);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: UIKit.width(20), vertical: UIKit.height(20)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.network(
              UIKit.getNetworkImgPath(model?.picture?.picCoverSmall),
              height: UIKit.height(180),
            ),
            Expanded(
                child: Container(
                    height: UIKit.height(180),
                    padding: EdgeInsets.only(left: UIKit.width(20)),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(model?.roomName),
                              Text(
                                model?.statusName ?? '未知状态',
                                style:
                                    TextStyle(color: const Color(0xFFDE6D6C)),
                              )
                            ],
                          ),
                          Text(sizeText),
                          Text(model?.style, style: textTheme.caption),
                          Text(model?.mode, style: textTheme.caption)
                        ]))),
          ],
        ),
      ),
    );
  }
}

class MeasureOrderHasNotSelectedProductItemView extends StatelessWidget {
  final OrderModelData orderModelData;
  final OrderModel model;
  final int id;
  final int tab;
  const MeasureOrderHasNotSelectedProductItemView(
      {Key key, this.orderModelData, this.model, this.id, this.tab})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;

    return InkWell(
      onTap: () {
        RouteHandler.goOrderDetailPage(context, id);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: UIKit.width(20), vertical: UIKit.height(20)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ZYNetImage(
              imgPath: model?.picture?.picCoverSmall ?? '',
              height: UIKit.height(180),
            ),
            Expanded(
                child: Container(
                    height: UIKit.height(180),
                    padding: EdgeInsets.only(left: UIKit.width(20)),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '测量单',
                                style: textTheme.title.copyWith(
                                    fontSize: UIKit.sp(32),
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                model?.statusName ?? '未知状态',
                                style:
                                    TextStyle(color: const Color(0xFFDE6D6C)),
                              ),
                            ],
                          ),
                          Text(
                            '${orderModelData?.orderWindowNum ?? 0}扇',
                            style: textTheme.body1
                                .copyWith(fontSize: UIKit.sp(28)),
                          ),
                          Text(
                            '客户:${orderModelData?.clientName ?? ''}',
                            style: textTheme.caption
                                .copyWith(fontSize: UIKit.sp(24)),
                          ),
                          Text(
                            '订单编号:${orderModelData?.orderNo}',
                            style: textTheme.caption
                                .copyWith(fontSize: UIKit.sp(24)),
                          ),
                        ]))),
          ],
        ),
      ),
    );
  }
}
