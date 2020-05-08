import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/constants/constants.dart';
import 'package:taojuwu/models/order/order_model.dart';
import 'package:taojuwu/models/zy_response.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/v_spacing.dart';

class OrderCard extends StatelessWidget {
  final OrderModelData orderModelData;
  const OrderCard(this.orderModelData, {Key key}) : super(key: key);
  bool get showButton =>
      Constants
          .ORDER_STATUS_BUTTON_TEXT_MAP[orderModelData?.statusName ?? ''] !=
      null;
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;

    String createTime = DateUtil.formatDateMs(orderModelData?.createTime ?? 0,
        format: 'yyyy-MM-dd HH:mm:ss');
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
                  id: orderModelData?.orderId);
            }),
          ),
          Row(
            children: <Widget>[
              Expanded(child: SizedBox()),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text('应收定金:${orderModelData?.orderEarnestMoney}'),
                  Text(
                    '创建时间:$createTime',
                    style: textTheme.caption,
                  ),
                  showButton
                      ? OutlineButton(
                          onPressed: () {
                            OTPService.orderRemind(params: {
                              'order_id': orderModelData?.orderId,
                              'status': Constants.ORDER_STATUS_BUTTON_ACTION[
                                  orderModelData?.orderStatus ?? '']
                            }).then((ZYResponse response) {
                              print(response);
                            }).catchError((err) => err);
                          },
                          child: Text(Constants.ORDER_STATUS_BUTTON_TEXT_MAP[
                                  orderModelData?.statusName ?? ''] ??
                              ''),
                        )
                      : VSpacing(20),
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
  const OrderItemView(this.model,
      {Key key, this.orderNo: '', this.name: '', this.id})
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
            Image.network(
              UIKit.getNetworkImgPath(model?.picture?.picCoverSmall),
              height: UIKit.height(180),
            ),
            Expanded(
                child: Container(
              height: UIKit.height(180),
              padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(model?.goodsName),
                  Text.rich(TextSpan(
                      text: '￥${model?.price ?? '0.00'}',
                      children: [
                        TextSpan(text: '/米', style: textTheme.caption)
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
            Text(
              model?.statusName ?? '未知状态',
              style: TextStyle(color: const Color(0xFFDE6D6C)),
            ),
          ],
        ),
      ),
    );
  }
}
