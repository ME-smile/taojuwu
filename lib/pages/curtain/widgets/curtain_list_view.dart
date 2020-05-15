import 'package:flutter/material.dart';
import 'package:taojuwu/models/shop/curtain_product_list_model.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';

class _ListCard extends StatelessWidget {
  final CurtainGoodItemBean bean;
  const _ListCard(this.bean, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        RouteHandler.goCurtainDetailPage(context, bean?.goodsId);
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
        child: Column(
          children: <Widget>[
            // ExtendedImage.network(
            //   UIKit.getNetworkImgPath(
            //     bean?.picCoverMid,
            //   ),
            //   width: width - 2 * UIKit.width(20),
            //   fit: BoxFit.fill,
            // ),
            ZYNetImage(
              imgPath: UIKit.getNetworkImgPath(
                bean?.picCoverMid,
              ),
              fit: BoxFit.fill,
              width: width - 2 * UIKit.width(20),
            ),

            Text(bean?.goodsName ?? ''),
            Text('${bean?.displayPrice ?? "0.00"}')
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
            goodsList != null && goodsList.isNotEmpty ? goodsList.length : 0,
        itemBuilder: (BuildContext context, int i) {
          return _ListCard(goodsList[i]);
        });
  }
}
