import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/models/order/order_detail_model.dart';
import 'package:taojuwu/models/order/order_model.dart';
import 'package:taojuwu/pages/order/utils/order_kit.dart';

import 'package:taojuwu/providers/order_detail_provider.dart';

import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/v_spacing.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';
import 'package:taojuwu/widgets/zy_outline_button.dart';

class OrderAttrCard extends StatelessWidget {
  final OrderGoods goods;
  final OrderDetailModel model;

  const OrderAttrCard({Key key, this.goods, this.model}) : super(key: key);

  bool get canCancelGoods => goods?.refundStatus == 0;
  bool get showCancelButton =>
      [1, 2, 3, 4, 14].contains(model?.orderStatus) ?? false;
  @override
  Widget build(BuildContext context) {
    List<OrderProductAttrWrapper> attrs = goods.wcAttr;
    String attrsText = '';

    attrs.forEach((OrderProductAttrWrapper item) {
      attrsText +=
          '${item.attrName}: ${item.attrs.map((item) => item.name).toList().join('')}  ';
    });
    attrsText +=
        ' 离地距离: ${goods?.orderGoodsMeasure?.verticalGroundHeight ?? 0}cm';
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Row(
          children: <Widget>[
            ZYNetImage(
              imgPath: goods?.pictureInfo?.picCoverSmall ?? '',
              width: UIKit.width(200),
            ),
            Expanded(
                child: Container(
              // height: UIKit.height(180),
              padding: EdgeInsets.only(left: UIKit.width(20)),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(goods?.goodsName ?? ''),
                      Text('¥ ${goods?.price ?? 0.00}/米'),
                    ],
                  ),
                  VSpacing(20),
                  Text(
                    attrsText,
                    style: textTheme.caption,
                  ),
                  VSpacing(10),
                ],
              ),
            )),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Offstage(
              offstage: goods?.showExpressInfo == false,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: UIKit.height(10)),
                child: Text('物流编号:${goods?.expressInfo?.expressNo}'),
              ),
            ),
            Text.rich(TextSpan(
                text: '小计 ',
                style: textTheme.caption.copyWith(fontSize: UIKit.sp(20)),
                children: [
                  TextSpan(
                      text: '¥${goods?.estimatedPrice ?? 0.00}',
                      style: textTheme.body1.copyWith(fontSize: UIKit.sp(24))),
                ]))
          ],
        ),
        showCancelButton
            ? Consumer<OrderDetailProvider>(
                builder:
                    (BuildContext context, OrderDetailProvider provider, _) {
                  return OrderKit.buildOrderGoodsActionButton(
                      context, goods, provider);
                },
              )
            : Container()
      ],
    ));
  }

  Widget buildActionButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        CancelOrderGoodsButton(goods),
      ],
    );
  }
}

class CancelOrderGoodsButton extends StatelessWidget {
  final OrderGoods goods;
  const CancelOrderGoodsButton(
    this.goods, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderDetailProvider>(
      builder:
          (BuildContext context, OrderDetailProvider orderDetailProvider, _) {
        return ZYOutlineButton(
          goods?.canCancel == true ? '取消' : '取消待审核',
          () {
            orderDetailProvider?.cancelOrderGoods(context, goods);
          },
          isActive: goods?.canCancel ?? true,
        );
      },
    );
  }
}
