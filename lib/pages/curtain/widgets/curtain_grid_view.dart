import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/constants/constants.dart';
import 'package:taojuwu/models/shop/curtain_product_list_model.dart';
import 'package:taojuwu/pages/curtain/curtain_detail_page.dart';
import 'package:taojuwu/pages/curtain/widgets/onsale_tag.dart';

import 'package:taojuwu/utils/ui_kit.dart';

import 'package:taojuwu/widgets/zy_netImage.dart';

class GridCard extends StatelessWidget {
  final CurtainGoodItemBean bean;
  const GridCard(this.bean, {Key key}) : super(key: key);

  Widget buildContent(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    return Container(
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionType: ContainerTransitionType.fade,
      transitionDuration: Constants.TRANSITION_DURATION,
      useRootNavigator: false,
      closedElevation: 0,
      openElevation: 0,
      onClosed: (_) {
        // Navigator.of(context).pop();
        // Navigator.of(context).removeRoute(MaterialPageRoute(
        //     builder: (BuildContext context) => CurtainMallPage()));
      },
      closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0))),
      closedBuilder: (BuildContext context, VoidCallback _) {
        return buildContent(context);
      },
      openBuilder: (BuildContext context, VoidCallback _) {
        return CurtainDetailPage(
          bean?.goodsId,
          heroImg: bean?.picCoverMid,
        );
      },
    );
    // return InkWell(
    //   onTap: () {
    //     RouteHandler.goCurtainDetailPage(context, bean?.goodsId);
    //   },
    //   child: Container(
    //     alignment: Alignment.center,
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       // mainAxisSize: MainAxisSize.min,
    //       children: <Widget>[
    //         ZYNetImage(
    //           imgPath: bean?.picCoverMid ?? '',
    //           width: (width - 20) / 2,
    //           height: (width - 20) / 2,
    //           fit: BoxFit.cover,
    //           callback: () {
    //             RouteHandler.goCurtainDetailPage(context, bean?.goodsId);
    //           },
    //         ),
    //         Expanded(
    //           child: Row(
    //             children: <Widget>[
    //               Text(bean?.goodsName ?? '',
    //                   maxLines: 1,
    //                   overflow: TextOverflow.ellipsis,
    //                   textAlign: TextAlign.left,
    //                   style: TextStyle(fontSize: UIKit.sp(30))),
    //               Offstage(
    //                 offstage: bean?.isPromotionGoods == false,
    //                 child: OnSaleTag(),
    //               ),
    //             ],
    //           ),
    //         ),
    //         Expanded(
    //             child: Text.rich(TextSpan(
    //                 text: '￥${bean.displayPrice ?? "0.00"}',
    //                 style: TextStyle(fontSize: UIKit.sp(32)),
    //                 children: [
    //               TextSpan(
    //                 text: '起',
    //                 style: themeData.textTheme.caption
    //                     .copyWith(fontSize: UIKit.sp(22)),
    //               ),
    //               TextSpan(
    //                 text: ' ',
    //               ),
    //               TextSpan(
    //                   text: bean?.isPromotionGoods == true
    //                       ? '￥${bean?.marketPrice}起'
    //                       : '',
    //                   style: themeData.textTheme.caption
    //                       .copyWith(decoration: TextDecoration.lineThrough)),
    //               // TextSpan(text: '\n'),
    //               // TextSpan(text: '11324'),
    //             ]))),
    //       ],
    //     ),
    //   ),
    // );
  }
}

class GoodsGridView extends StatelessWidget {
  final List<CurtainGoodItemBean> goodsList;

  const GoodsGridView(this.goodsList, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: .8,
          crossAxisSpacing: 10,
        ),
        itemCount:
            goodsList != null && goodsList.isNotEmpty ? goodsList.length : 0,
        itemBuilder: (BuildContext context, int i) {
          return GridCard(goodsList[i]);
        });
  }
}
