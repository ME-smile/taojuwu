import 'package:flutter/material.dart';

import 'package:taojuwu/repository/shop/curtain_product_list_model.dart';

import 'package:taojuwu/view/goods/base/onsale_tag.dart';
import 'package:taojuwu/router/handlers.dart';

import 'package:taojuwu/utils/ui_kit.dart';

import 'package:taojuwu/widgets/zy_netImage.dart';

class GridCard extends StatelessWidget {
  final GoodsItemBean bean;
  final bool isMeasureOrderGoods;
  const GridCard(this.bean, {Key key, this.isMeasureOrderGoods = false})
      : super(key: key);

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
                text: '￥${bean?.displayPrice?.toStringAsFixed(2) ?? "0.00"}',
                style: TextStyle(fontSize: UIKit.sp(32)),
                children: [
                  TextSpan(
                    text: '￥${bean?.unit ?? ""}',
                    style: themeData.textTheme.caption
                        .copyWith(fontSize: UIKit.sp(20)),
                  ),
                  TextSpan(
                    text: ' ',
                  ),
                  TextSpan(
                    text: bean?.isPromotionGoods == true
                        ? '￥${bean?.marketPrice?.toStringAsFixed(2)}起'
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

  jump(BuildContext context, int type) {
    if (type == 0) {
      return RouteHandler.goEndProductDetail(context, bean?.goodsId);
    }
    if (type == 1) {
      return RouteHandler.goFabricCurtainProductDetailPage(
          context, bean?.goodsId,
          isMeasureOrderGoods: isMeasureOrderGoods ? 1 : 0);
    }
    if (type == 2) {
      return RouteHandler.goRollingCurtainProductDetailPage(
          context, bean?.goodsId,
          isMeasureOrderGoods: isMeasureOrderGoods ? 1 : 0);
    }
    if (type == 3) {
      return RouteHandler.goGauzeCurtainProductDetailPage(
          context, bean?.goodsId,
          isMeasureOrderGoods: isMeasureOrderGoods ? 1 : 0);
    }
    if (type == 4) {
      return RouteHandler.goSectionalbarProductDetailPage(
          context, bean?.goodsId,
          isMeasureOrderGoods: isMeasureOrderGoods ? 1 : 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        jump(context, bean?.goodsType);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        child: Container(
          margin: EdgeInsets.only(top: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                child: ZYNetImage(
                  imgPath: bean?.picCoverMid ?? '',
                  width: (width - 20) / 2,
                  height: (width - 20) / 2,
                  fit: BoxFit.cover,
                  callback: () {
                    jump(context, bean?.goodsType);
                  },
                ),
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
                      text: '米',
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
              // VSpacing(20),
            ],
          ),
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
            childAspectRatio: 0.8,
            crossAxisSpacing: 10,
            mainAxisSpacing: 8),
        itemCount:
            goodsList != null && goodsList.isNotEmpty ? goodsList.length : 0,
        itemBuilder: (BuildContext context, int i) {
          return GridCard(goodsList[i]);
        });
  }
}
