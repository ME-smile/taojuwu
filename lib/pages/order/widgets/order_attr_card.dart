import 'package:flutter/material.dart';
import 'package:taojuwu/models/order/order_detail_model.dart';
import 'package:taojuwu/models/order/order_model.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/v_spacing.dart';

class OrderAttrCard extends StatelessWidget {
  final OrderGoods goods;
  const OrderAttrCard({Key key, this.goods}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<OrderProductAttrWrapper> attrs = goods.wcAttr;
    String attrsText = '';
    attrs.forEach((OrderProductAttrWrapper item) {
      attrsText +=
          '${item.attrName}: ${item.attrs.map((item) => item.name).toList().join('')}  ';
    });
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      child: Row(
        children: <Widget>[
          Image.network(
            UIKit.getNetworkImgPath(goods?.pictureInfo?.picCoverSmall??''),
            height: UIKit.height(180),
          ),
          Expanded(
              child: Container(
            height: UIKit.height(180),
            padding: EdgeInsets.only(
            left: UIKit.width(20)
            ),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(goods?.goodsName ?? ''),
                    Text('¥ ${goods?.price??0.00}/米'),
                  ],
                ),
                VSpacing(20),
                Text(attrsText,style: textTheme.caption,),
                
              ],
            ),
          )),

        ],
      ),
    );
  }
}
