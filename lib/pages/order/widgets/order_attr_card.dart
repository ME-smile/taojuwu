import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/models/order/order_detail_model.dart';
import 'package:taojuwu/pages/order/utils/order_kit.dart';

import 'package:taojuwu/providers/order_detail_provider.dart';
import 'package:taojuwu/utils/common_kit.dart';

import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/copy_button.dart';
import 'package:taojuwu/widgets/v_spacing.dart';
import 'package:taojuwu/widgets/zy_outline_button.dart';
import 'package:taojuwu/widgets/zy_photo_view.dart';

class OrderAttrCard extends StatelessWidget {
  final OrderGoods goods;
  final OrderDetailModel model;

  const OrderAttrCard({Key key, this.goods, this.model}) : super(key: key);

  bool get canCancelGoods => goods?.refundStatus == 0;
  bool get showCancelButton =>
      [1, 2, 3, 4, 14].contains(model?.orderStatus) ?? false;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Row(
          children: <Widget>[
            ZYPhotoView(
              UIKit.getNetworkImgPath(goods?.pictureInfo?.picCoverSmall ?? ''),
              width: UIKit.width(200),
              tag: CommonKit.getRandomStr(),
            ),
            // ZYNetImage(
            //   imgPath: goods?.pictureInfo?.picCoverSmall ?? '',
            //   width: UIKit.width(200),
            // ),
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
                      Text(goods?.goodsName ?? '' + ''),
                      Text(
                        model?.statusName ?? '',
                        style: TextStyle(
                            color: Color(0xFFFC5252),
                            fontSize: UIKit.sp(28),
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('¥ ${goods?.price ?? 0.00}${goods?.unit}'),
                    ],
                  ),
                  Text(
                    goods?.goodsAttrStr ?? '',
                    style: textTheme.caption.copyWith(fontSize: UIKit.sp(22)),
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
                child: Text.rich(TextSpan(
                    text: '物流编号:${goods?.expressInfo?.expressNo ?? ''}',
                    style: textTheme.caption,
                    children: [
                      TextSpan(text: '  '),
                      WidgetSpan(
                        child: CopyButton(goods?.expressInfo?.expressNo ?? ''),
                      )
                    ])),
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
        return goods?.hasAlreadyCancel == true
            ? ZYOutlineButton('已取消', null)
            : ZYOutlineButton(
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
