import 'package:flutter/material.dart';

import 'package:taojuwu/repository/shop/curtain_product_list_model.dart';

import 'package:taojuwu/view/goods/base/onsale_tag.dart';
import 'package:taojuwu/router/handlers.dart';

import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/v_spacing.dart';

import 'package:taojuwu/widgets/zy_netImage.dart';

class GridCard extends StatelessWidget {
  final GoodsItemBean bean;
  const GridCard(this.bean, {Key key}) : super(key: key);

  Widget buildContent(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    return Container(
      key: ValueKey(bean?.goodsId),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        // mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ZYNetImage(
            imgPath: bean?.picCoverMid ?? '',
            width: (width - 20) / 2,
            height: (width - 20) / 2,
            fit: BoxFit.cover,
            // callback: () {
            //   RouteHandler.goCurtainDetailPage(context, bean?.goodsId);
            // },
          ),
          Expanded(
              child: Container(
            color: themeData.primaryColor,
            // padding: EdgeInsets.only(left: 20),
            child: Row(
              children: <Widget>[
                Text(bean?.goodsName ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: UIKit.sp(30))),
                Visibility(
                  visible: bean?.isPromotionGoods == true,
                  child: OnSaleTag(),
                ),
              ],
            ),
          )),
          Expanded(
              child: Container(
            color: themeData.primaryColor,
            child: Text.rich(TextSpan(
                text: '￥${bean?.displayPrice ?? "0.00"}',
                style: TextStyle(fontSize: UIKit.sp(32)),
                children: [
                  TextSpan(
                    text: '起',
                    style: themeData.textTheme.caption
                        .copyWith(fontSize: UIKit.sp(20)),
                  ),
                  TextSpan(
                    text: ' ',
                  ),
                  TextSpan(
                    text: bean?.isPromotionGoods == true
                        ? '￥${bean?.marketPrice}起'
                        : '',
                    style: themeData.textTheme.caption.copyWith(
                        decoration: TextDecoration.lineThrough,
                        fontSize: UIKit.sp(20)),
                  ),
                  // TextSpan(text: '\n'),
                  // TextSpan(text: '11324'),
                ])),
          )),
        ],
      ),
    );
  }

  jump(BuildContext context) {
    if (bean?.isCustomizedProduct == true)
      return RouteHandler.goCurtainDetailPage(context, bean?.goodsId);
    return RouteHandler.goEndProductDetail(context, bean?.goodsId);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        jump(context);
      },
      child: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ZYNetImage(
              imgPath: bean?.picCoverMid ?? '',
              width: (width - 20) / 2,
              height: (width - 20) / 2,
              fit: BoxFit.cover,
              callback: () {
                jump(context);
              },
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Text(bean?.goodsName ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: UIKit.sp(30))),
                  Offstage(
                    offstage: bean?.isPromotionGoods == false,
                    child: OnSaleTag(),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Text.rich(TextSpan(
                    text: '￥${bean.displayPrice ?? "0.00"}',
                    style: TextStyle(fontSize: UIKit.sp(32)),
                    children: [
                  TextSpan(
                    text: '起',
                    style: themeData.textTheme.caption
                        .copyWith(fontSize: UIKit.sp(22)),
                  ),
                  TextSpan(
                    text: ' ',
                  ),
                  TextSpan(
                      text: bean?.isPromotionGoods == true
                          ? '￥${bean?.marketPrice}起'
                          : '',
                      style: themeData.textTheme.caption
                          .copyWith(decoration: TextDecoration.lineThrough)),
                  // TextSpan(text: '\n'),
                  // TextSpan(text: '11324'),
                ]))),
            VSpacing(20),
          ],
        ),
      ),
    );
  }
}

class GoodsGridView extends StatelessWidget {
  final List<GoodsItemBean> goodsList;

  const GoodsGridView(this.goodsList, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.all(5),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.0,
            crossAxisSpacing: 10,
            mainAxisSpacing: 8),
        itemCount:
            goodsList != null && goodsList.isNotEmpty ? goodsList.length : 0,
        itemBuilder: (BuildContext context, int i) {
          return GridCard(goodsList[i]);
        });
  }
}
