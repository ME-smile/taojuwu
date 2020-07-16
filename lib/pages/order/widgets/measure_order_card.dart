import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/models/order/order_model.dart';
import 'package:taojuwu/pages/order/utils/order_kit.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';

class MeasureOrderCard extends StatelessWidget {
  final OrderModelData orderModelData;
  final bool canClick;
  const MeasureOrderCard({Key key, this.orderModelData, this.canClick: false})
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

    final List<OrderModel> models = orderModelData?.models;
    return Container(
      color: themeData.primaryColor,
      padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          ListBody(
            children: List.generate(models?.length ?? 0, (int i) {
              OrderModel item = models[i];
              return InkWell(
                onTap: canClick
                    ? () {
                        RouteHandler.goOrderDetailPage(
                            context, orderModelData?.orderId);
                      }
                    : null,
                child: Container(
                  child: item?.hasAudit == false
                      ? MeasureOrderHasNotAuditCard(
                          orderModelData: orderModelData,
                          model: item,
                        )
                      : orderModelData?.hasNotsSelectedProduct == true
                          ? MeasureOrderBeforePayCard(
                              model: item,
                              orderModelData: orderModelData,
                            )
                          : item?.hasSelectedGoods == true
                              ? MeasureOrderHasSelectedProductCard(
                                  model: item, id: orderModelData?.orderId)
                              : MeasureOrderHasNotSelectedProductCard(
                                  model: item,
                                  orderModelData: orderModelData,
                                ),
                ),
              );
            }),
          ),
          OrderKit.buildOrderInfoText(context, orderModelData),
          OrderKit.buildButton(context, orderModelData, callback: () {
            RouteHandler.goOrderDetailPage(context, orderModelData?.orderId);
          })
        ],
      ),
    );
  }
}

class MeasureOrderHasSelectedProductCard extends StatelessWidget {
  final OrderModel model;
  final int id;
  const MeasureOrderHasSelectedProductCard({Key key, this.model, this.id})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: UIKit.width(20), vertical: UIKit.height(20)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ZYNetImage(
            imgPath: UIKit.getNetworkImgPath(model?.picture?.picCoverSmall),
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
                            Text(model?.goodsName),
                            Text(
                              model?.statusName ?? '未知状态',
                              style: TextStyle(color: const Color(0xFFDE6D6C)),
                            )
                          ],
                        ),
                        Text(
                          '￥${model?.price ?? '0.00'}${model?.unit}',
                          style: textTheme.caption,
                        ),
                        Text('空间:${model?.roomName ?? ''}',
                            style: textTheme.caption),
                        Text(model?.sizeTextDesc ?? '',
                            style: textTheme.caption),
                      ]))),
        ],
      ),
    );
  }
}

class MeasureOrderHasNotAuditCard extends StatelessWidget {
  final OrderModel model;

  final OrderModelData orderModelData;
  const MeasureOrderHasNotAuditCard({Key key, this.orderModelData, this.model})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: UIKit.width(20), vertical: UIKit.height(20)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ZYNetImage(
            imgPath: UIKit.getNetworkImgPath(model?.picture?.picCoverSmall),
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
                            Text(orderModelData?.orderTypeName ?? ''),
                            Text(
                              model?.statusName ?? '未知状态',
                              style: TextStyle(color: const Color(0xFFDE6D6C)),
                            )
                          ],
                        ),
                        Text('${orderModelData?.orderWindowNum ?? 0}扇'),
                        Text('客户:${orderModelData?.clientName}',
                            style: textTheme.caption),
                        Text('订单编号:${orderModelData?.orderNo ?? ''}',
                            style: textTheme.caption)
                      ]))),
        ],
      ),
    );
  }
}

class MeasureOrderHasNotSelectedProductCard extends StatelessWidget {
  final OrderModel model;

  final OrderModelData orderModelData;
  const MeasureOrderHasNotSelectedProductCard(
      {Key key, this.model, this.orderModelData})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: UIKit.width(20), vertical: UIKit.height(20)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ZYNetImage(
            imgPath: UIKit.getNetworkImgPath(model?.picture?.picCoverSmall),
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
                            Text(model?.goodsName ?? ''),
                            Text(
                              model?.statusName ?? '未知状态',
                              style: TextStyle(color: const Color(0xFFDE6D6C)),
                            )
                          ],
                        ),
                        Text(
                            '¥${model?.price?.toStringAsFixed(2)}${model?.unit}'),
                        Text('客户:${orderModelData?.clientName}',
                            style: textTheme.caption),
                        Text('订单编号:${orderModelData?.orderNo}',
                            style: textTheme.caption),
                        // Text(model?.sizeTextDesc ?? '',
                        //     style: textTheme.caption),
                      ]))),
        ],
      ),
    );
  }
}

class MeasureOrderBeforePayCard extends StatelessWidget {
  final OrderModel model;

  final OrderModelData orderModelData;
  const MeasureOrderBeforePayCard({Key key, this.model, this.orderModelData})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: UIKit.width(20), vertical: UIKit.height(20)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ZYNetImage(
            imgPath: UIKit.getNetworkImgPath(model?.picture?.picCoverSmall),
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
                            Text(model?.roomName ?? ''),
                            Text(
                              model?.statusName ?? '未知状态',
                              style: TextStyle(color: const Color(0xFFDE6D6C)),
                            )
                          ],
                        ),
                        Text('${model?.sizeTextDesc}'),
                        Text('${model?.style}', style: textTheme.caption),
                        Text(
                          '${model?.mode}',
                          style: textTheme.caption,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // Text(model?.sizeTextDesc ?? '',
                        //     style: textTheme.caption),
                      ]))),
        ],
      ),
    );
  }
}
