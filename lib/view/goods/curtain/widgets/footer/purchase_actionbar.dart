import 'package:flutter/material.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/viewmodel/goods/binding/base/base_goods_binding.dart';

class PurchaseActionBar extends StatelessWidget {
  final BaseGoodsBinding baseGoodsBinding;
  const PurchaseActionBar(this.baseGoodsBinding, {Key key}) : super(key: key);

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
                  text: '${baseGoodsBinding.totlaPrice ?? "0.00"}',
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
                            onTap: baseGoodsBinding.addToFunc
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
                            ,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: UIKit.width(20),
                                  vertical: UIKit.height(11)),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: themeData.accentColor)),
                              // color: canAddToCart
                              //     ? themeData.accentColor
                              //     : themeData.disabledColor)),
                              child: Text(
                                '加入购物车',
                                textAlign: TextAlign.center,
                                // style: true
                                //     ? TextStyle()
                                //     : TextStyle(color: themeData.disabledColor),
                              ),
                            ),
                          );
                        },
                      ),
                      flex: 1,
                    ),
                    Expanded(
                        child: InkWell(
                          onTap: baseGoodsBinding.purchase,
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
