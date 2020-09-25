import 'package:flutter/material.dart';
import 'package:taojuwu/router/handlers.dart';

import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/kongo.dart';

class KongoBar extends StatelessWidget {
  final int id;
  final String name;
  const KongoBar({Key key, this.id, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List kongos = [
      {
        'icon': 'collection@2x.png',
        'title': '收藏夹',
        'callback': () {
          RouteHandler.goCollectPage(context, clientId: id, name: name);
        }
      },
      {
        'icon': 'cart@2x.png',
        'title': '购物车',
        'callback': () {
          RouteHandler.goCartPage(context, clientId: id);
        }
      },
      {
        'icon': 'order_black@2x.png',
        'title': '订单',
        'callback': () {
          RouteHandler.goOrderPage(context, clientId: id);
        }
      },
      {
        'icon': 'refund@2x.png',
        'title': '退款/售后',
        'callback': () {
          RouteHandler.goRefundPage(context, id);
        }
      }
    ];

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: UIKit.width(20), vertical: UIKit.height(20)),
      padding: EdgeInsets.symmetric(vertical: UIKit.height(20)),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: [
            BoxShadow(
              color: Color(0x1F000000),
              spreadRadius: 1.0,
              blurRadius: 1,
            ),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(kongos.length, (int i) {
          return Kongo(
            iconPath: kongos[i]['icon'],
            text: kongos[i]['title'],
            callback: kongos[i]['callback'],
          );
        }),
      ),
    );
  }
}
