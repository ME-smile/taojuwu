import 'package:flutter/material.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/triangle_clipper.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';
// import 'package:taojuwu/widgets/zy_netImage.dart';

class OptionView extends StatelessWidget {
  final String img;
  final String text;
  final String price;
  final Function callback;
  final bool showBorder;

  bool get showPrice => double.parse(price ?? '0.00') != 0.0;
  const OptionView(
      {Key key,
      this.img,
      this.text: '',
      this.callback,
      this.showBorder: false,
      this.price: ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return GestureDetector(
      onTap: callback,
      child: Container(
        width: width / 5,
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: showBorder
                              ? Theme.of(context).accentColor
                              : Colors.transparent,
                          width: 1.2),
                    ),
                    width: UIKit.width(150),
                    height: UIKit.width(150),
                    child: ZYNetImage(
                      imgPath: UIKit.getNetworkImgPath(img),
                    ),
                  ),
                  Positioned(
                    child: showBorder ? TriAngle() : Container(),
                    right: 0,
                    bottom: 0,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: UIKit.height(10)),
              child: Text(
                text,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: showBorder
                    ? textTheme.bodyText2.copyWith(fontSize: 12)
                    : textTheme.caption.copyWith(fontSize: 12),
              ),
            ),
            Offstage(
              offstage: !showPrice,
              child: Padding(
                padding: EdgeInsets.only(top: UIKit.height(10)),
                child: Text(
                  '¥$price',
                  textAlign: TextAlign.center,
                  style: showBorder
                      ? textTheme.bodyText2.copyWith(fontSize: 12)
                      : textTheme.caption.copyWith(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
