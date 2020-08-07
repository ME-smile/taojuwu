import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/models/base/goods_attr.dart';
import 'package:taojuwu/models/shop/cart_list_model.dart';

import 'package:taojuwu/router/handlers.dart';

class GoodsAttrCard extends StatelessWidget {
  final int clientId;
  final List<GoodsAttr> attrs;
  final CartModel cartModel;
  final bool isInCartPage;
  final Function callback;

  const GoodsAttrCard(
      {Key key,
      this.cartModel,
      this.clientId,
      this.callback,
      this.isInCartPage: true,
      this.attrs})
      : super(key: key);

  int get goodsId => cartModel?.goodsId;
  int get cartId => cartModel?.cartId;
  List<GoodsAttr> get attrList => attrs ?? cartModel?.attrs;
  List<GoodsAttr> get selectedValueAttrs =>
      attrList?.where((element) => element?.visible)?.toList();
  String get params => jsonEncode(attrList?.map((e) => e?.toJson())?.toList());
  @override
  Widget build(BuildContext context) {
    if (selectedValueAttrs?.isEmpty == true) return SizedBox.shrink();
    return InkWell(
      onTap: isInCartPage
          ? () {
              if (callback != null) callback();
              RouteHandler.goEditGoodsAttrPage(
                context,
                goodsId: goodsId,
                params: params,
                clientId: clientId,
                cartId: cartId,
              );
            }
          : null,
      child: Container(
        margin:
            EdgeInsets.only(top: 10, bottom: 16, left: isInCartPage ? 48 : 0),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(color: Color(0xFFF5F5F9)),
        child: Row(
          children: <Widget>[
            Expanded(
                child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  childAspectRatio: 8),
              itemBuilder: (BuildContext context, int index) {
                GoodsAttr bean = selectedValueAttrs[index];
                return Offstage(
                  child: Container(
                    child: Text(
                      '${bean?.name ?? ''}:${bean?.value ?? ''}',
                      style: TextStyle(color: Color(0xFF6D6D6D), fontSize: 12),
                    ),
                  ),
                  offstage: bean?.visible == false,
                );
              },
              itemCount: selectedValueAttrs?.length ?? 0,
            )),
            isInCartPage
                ? Container(
                    child: Icon(
                      ZYIcon.next,
                      size: 18,
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
