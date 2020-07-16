import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/constants/constants.dart';
import 'package:taojuwu/models/order/order_model.dart';
import 'package:taojuwu/pages/order/utils/order_kit.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';

class OrderCard extends StatelessWidget {
  final OrderModelData orderModelData;
  final bool canClick;

  const OrderCard(this.orderModelData, {Key key, this.canClick: false})
      : super(key: key);

  String get createTimeStr {
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

  bool get showButton =>
      Constants.ORDER_STATUS_BUTTON_ACTION[orderModelData?.orderStatus ?? 0]
          ['show_button'];

  Function callback(BuildContext context) {
    Map<int, Function> dict = {
      1: remindOrder(context, '是否提醒审核', 1),
      2: remindOrder(context, '是否提醒测量', 2),
      3: remindOrder(context, '是否提醒退款', 3),
      6: remindOrder(context, '是否提醒安装', 3),
      8: () {
        RouteHandler.goAfterSaleServicePage(context);
      },
      14: () {
        RouteHandler.goOrderDetailPage(context, orderModelData?.orderId);
      }
    };

    return dict[orderModelData?.orderStatus];
  }

  Function remindOrder(BuildContext context, String title, int status) {
    Function fn = () {
      OrderKit.remindOrder(context, title, orderModelData?.orderId, status)
          .catchError((err) => err);
    };
    return fn;
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
        children: <Widget>[
          ListBody(
            children: List.generate(models?.length ?? 0, (int i) {
              return OrderItemView(models[i],
                  name: orderModelData?.clientName,
                  orderNo: orderModelData?.orderNo,
                  canClick: canClick,
                  id: orderModelData?.orderId);
            }),
          ),
          Row(
            children: <Widget>[
              Expanded(child: SizedBox()),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text('已收定金:${orderModelData?.orderEarnestMoneyStr}'),
                  Text(
                    '创建时间:$createTimeStr',
                    style: textTheme.caption,
                  ),
                  OrderKit.buildButton(context, orderModelData, callback: () {
                    RouteHandler.goOrderDetailPage(
                        context, orderModelData?.orderId);
                  })
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OrderItemView extends StatelessWidget {
  final OrderModel model;
  final String name;
  final String orderNo;
  final int id;
  final bool canClick;
  const OrderItemView(this.model,
      {Key key, this.orderNo: '', this.name: '', this.id, this.canClick: false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;

    return InkWell(
      onTap: canClick
          ? () {
              RouteHandler.goOrderDetailPage(context, id);
            }
          : null,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: UIKit.width(20), vertical: UIKit.height(20)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ZYNetImage(
              imgPath: model?.picture?.picCoverSmall,
              height: UIKit.height(180),
            ),
            // Image.network(
            //   UIKit.getNetworkImgPath(model?.picture?.picCoverSmall),
            //   height: UIKit.height(180),
            // ),
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
                      ),
                    ],
                  ),
                  Text.rich(
                      TextSpan(text: '￥${model?.price ?? '0.00'}', children: [
                    TextSpan(text: '${model?.unit}', style: textTheme.caption)
                  ])),
                  Text(
                    '客户: $name',
                    style: textTheme.caption,
                  ),
                  Text(
                    '订单编号: $orderNo',
                    style: textTheme.caption,
                  )
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
