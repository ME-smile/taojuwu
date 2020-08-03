import 'package:flutter/material.dart';

import 'package:taojuwu/utils/ui_kit.dart';

class PurchaseActionBar extends StatefulWidget {
  final String totalPrice;
  final Function addToCartFunc;
  final Function purchaseFunc;
  final bool canAddToCart;

  final GlobalKey cartKey;
  final GlobalKey rootKey;
  const PurchaseActionBar(
      {Key key,
      this.totalPrice,
      this.addToCartFunc,
      this.purchaseFunc,
      this.cartKey,
      this.rootKey,
      this.canAddToCart = true})
      : super(key: key);

  @override
  _PurchaseActionBarState createState() => _PurchaseActionBarState();
}

class _PurchaseActionBarState extends State<PurchaseActionBar> {
  String get totalPrice => widget.totalPrice;
  Function get addToCartFunc => widget.addToCartFunc;
  Function get purchaseFunc => widget.purchaseFunc;
  bool get canAddToCart => widget.canAddToCart;

  GlobalKey get rootKey => widget.rootKey;
  GlobalKey get cartKey => widget.cartKey;
  Offset startPoint;
  Offset endPoint;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   RenderBox renderBox = cartKey.currentContext.findRenderObject();
    //   endPoint = renderBox.localToGlobal(Offset.zero);
    // });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Container(
      color: themeData.primaryColor,
      padding: EdgeInsets.symmetric(
          horizontal: UIKit.width(20), vertical: UIKit.height(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text.rich(TextSpan(text: '预计:\n', children: [
              TextSpan(
                  text: '¥${totalPrice ?? 0.00}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            ])),
          ),
          Expanded(
              flex: 3,
              child: Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Builder(
                        builder: (BuildContext ctx) {
                          return InkWell(
                            onTap: canAddToCart
                                ? () {
                                    if (addToCartFunc != null) {
                                      addToCartFunc();
                                    }
                                    // OverlayEntry entry =
                                    //     OverlayEntry(builder: (_) {
                                    //   RenderBox box = ctx.findRenderObject();
                                    //   startPoint =
                                    //       box.localToGlobal(Offset.zero);

                                    //   return RedDotPage(
                                    //       startPosition: startPoint,
                                    //       endPosition: endPoint);
                                    // });
                                    // Overlay.of(context).insert(entry);
                                    // // 等待动画结束
                                    // Future.delayed(Duration(milliseconds: 800),
                                    //     () {
                                    //   entry.remove();
                                    //   entry = null;
                                    // });
                                  }
                                : null,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: UIKit.width(20),
                                  vertical: UIKit.height(11)),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1,
                                      color: canAddToCart
                                          ? themeData.accentColor
                                          : themeData.disabledColor)),
                              child: Text(
                                '加入购物车',
                                textAlign: TextAlign.center,
                                style: canAddToCart == true
                                    ? TextStyle()
                                    : TextStyle(color: themeData.disabledColor),
                              ),
                            ),
                          );
                        },
                      ),
                      flex: 1,
                    ),
                    Expanded(
                        child: InkWell(
                          onTap: () {
                            if (purchaseFunc != null) purchaseFunc();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: UIKit.height(11)),
                            decoration: BoxDecoration(
                                color: themeData.accentColor,
                                border:
                                    Border.all(color: themeData.accentColor)),
                            child: Text(
                              '立即购买',
                              style: themeData.accentTextTheme.button,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        flex: 1),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
