// import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
// import 'package:taojuwu/constants/constants.dart';

import 'package:taojuwu/models/shop/curtain_product_list_model.dart';
// import 'package:taojuwu/pages/curtain/curtain_detail_page.dart';
import 'package:taojuwu/pages/curtain/widgets/onsale_tag.dart';
import 'package:taojuwu/router/handlers.dart';
// import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';

class ListCard extends StatelessWidget {
  final CurtainGoodItemBean bean;
  const ListCard(this.bean, {Key key}) : super(key: key);

  Widget buildContent(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
      child: Column(
        children: <Widget>[
          ZYNetImage(
            imgPath: UIKit.getNetworkImgPath(
              bean?.picCoverMid,
            ),
            // callback: () {
            //   RouteHandler.goCurtainDetailPage(context, bean?.goodsId);
            // },
            fit: BoxFit.fill,
            width: width - 2 * UIKit.width(20),
          ),
          Text(bean?.goodsName ?? ''),
          Text('￥${bean?.displayPrice ?? "0.00"}'),
          Offstage(
            offstage: bean?.isPromotionGoods == false,
            child: OnSaleTag(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // return Container(
    //   width: double.infinity,
    //   margin: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
    //   child: Column(
    //     children: <Widget>[
    //       ZYNetImage(
    //         imgPath: UIKit.getNetworkImgPath(
    //           bean?.picCoverMid,
    //         ),
    //         // callback: () {
    //         //   RouteHandler.goCurtainDetailPage(context, bean?.goodsId);
    //         // },
    //         fit: BoxFit.fill,
    //         width: width - 2 * UIKit.width(20),
    //       ),
    //       Text(bean?.goodsName ?? ''),
    //       Text('￥${bean?.displayPrice ?? "0.00"}'),
    //       Offstage(
    //         offstage: bean?.isPromotionGoods == false,
    //         child: OnSaleTag(),
    //       ),
    //     ],
    //   ),
    // );
    // return OpenContainer(
    //   transitionDuration: Constants.TRANSITION_DURATION,
    //   closedColor: Colors.transparent,
    //   closedElevation: 0,
    //   closedShape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.all(Radius.circular(0))),
    //   closedBuilder: (BuildContext context, VoidCallback _) {
    //     return buildContent(context);
    //   },
    //   openBuilder: (BuildContext context, VoidCallback _) {
    //     return CurtainDetailPage(
    //       bean?.goodsId,
    //       heroImg: bean?.picCoverMid,
    //     );
    //   },
    // );
    return InkWell(
      onTap: () {
        RouteHandler.goCurtainDetailPage(context, bean?.goodsId);
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
        child: Column(
          children: <Widget>[
            ZYNetImage(
              imgPath: UIKit.getNetworkImgPath(
                bean?.picCoverMid,
              ),
              callback: () {
                RouteHandler.goCurtainDetailPage(context, bean?.goodsId);
              },
              fit: BoxFit.fill,
              width: width - 2 * UIKit.width(20),
            ),
            Text(bean?.goodsName ?? ''),
            Text('￥${bean?.displayPrice ?? "0.00"}'),
            Offstage(
              offstage: bean?.isPromotionGoods == false,
              child: OnSaleTag(),
            ),
          ],
        ),
      ),
    );
  }
}

class GoodsListView extends StatelessWidget {
  final List<CurtainGoodItemBean> goodsList;

  const GoodsListView(this.goodsList, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount:
            goodsList != null && goodsList.isNotEmpty ? goodsList?.length : 0,
        itemBuilder: (BuildContext context, int i) {
          return ListCard(goodsList[i]);
        });
  }
}
