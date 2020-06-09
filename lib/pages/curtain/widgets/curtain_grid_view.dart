import 'package:flutter/material.dart';
import 'package:taojuwu/models/shop/curtain_product_list_model.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';

class GridCard extends StatelessWidget {
  final CurtainGoodItemBean bean;
  const GridCard(this.bean, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        RouteHandler.goCurtainDetailPage(context, bean?.goodsId);
      },
      child: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ZYNetImage(
              imgPath: bean?.picCoverMid ?? '',
              width: (width - 20) / 2,
              height: (width - 20) / 2,
              fit: BoxFit.cover,
              callback: () {
                RouteHandler.goCurtainDetailPage(context, bean?.goodsId);
              },
            ),
            Expanded(
              child: Text(bean?.goodsName ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: UIKit.sp(30))),
            ),
            Expanded(
                child: Text.rich(TextSpan(
                    text: bean.displayPrice ?? "0.00",
                    style: TextStyle(fontSize: UIKit.sp(32)),
                    children: [
                  TextSpan(
                      text: '  起',
                      style: themeData.textTheme.caption
                          .copyWith(fontSize: UIKit.sp(22))),
                ]))),
          ],
        ),
      ),
    );
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
