import 'package:flutter/material.dart';
import 'package:taojuwu/utils/ui_kit.dart';

class CartButton extends StatelessWidget {
  final int count;

  final Function callback;
  const CartButton({
    Key key,
    this.count = 0,
    this.callback,
  }) : super(key: key);

  bool get isCartEmpty => count == 0;
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        width: UIKit.width(60),
        height: UIKit.width(60),
        alignment: Alignment(1.2, -1.5),
        child: isCartEmpty
            ? SizedBox.shrink()
            : Container(
                // width: 16,
                // height: 16,
                child: Text(
                  '$count',
                  textAlign: TextAlign.center,
                ),
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
              ),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(UIKit.getAssetsImagePath(
          'cart_blank@2x.png',
        )))),
      ),
    );
  }
}
