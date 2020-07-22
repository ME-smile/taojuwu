import 'package:flutter/material.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/models/base/goods_attr.dart';
import 'package:taojuwu/router/handlers.dart';

class GoodsAttrCard extends StatelessWidget {
  final int goodsId;
  final List<GoodsAttr> attrs;
  final bool isInCartPage;
  const GoodsAttrCard(
      {Key key, this.attrs, this.goodsId, this.isInCartPage: true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (attrs?.isEmpty == true) return Container();
    return InkWell(
      onTap: isInCartPage
          ? () {
              RouteHandler.goEditGoodsAttrPage(context, goodsId);
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
                GoodsAttr bean = attrs[index];
                return Container(
                  child: Text(
                    '${bean?.name ?? ''}:${bean?.value ?? ''}',
                    style: TextStyle(color: Color(0xFF6D6D6D), fontSize: 12),
                  ),
                );
              },
              itemCount: attrs?.length ?? 0,
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
