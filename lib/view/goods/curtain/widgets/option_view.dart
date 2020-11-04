/*
 * @Description: 属性的选项
 * @Author: iamsmiling
 * @Date: 2020-09-25 12:47:45
 * @LastEditTime: 2020-11-04 11:26:31
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/triangle_clipper.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';

class OptionView extends StatelessWidget {
  final bool isRoomAttr;
  final ProductSkuAttrBean bean;
  final Function callback;

  bool get showPrice => CommonKit.parseDouble(bean.price) != 0.0;

  bool get isChecked => bean.isChecked;

  const OptionView(this.bean, {Key key, this.callback, this.isRoomAttr = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isRoomAttr ? _buildButtonView(context) : _buildPictureView(context);
  }

  Widget _buildPictureView(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return GestureDetector(
      onTap: callback,
      child: Container(
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
                          color: isChecked
                              ? Theme.of(context).accentColor
                              : Colors.transparent,
                          width: 1.2),
                    ),
                    width: UIKit.width(150),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ZYNetImage(
                        imgPath: UIKit.getNetworkImgPath(bean.picture),
                      ),
                    ),
                  ),
                  Positioned(
                    child: isChecked ? TriAngle() : Container(),
                    right: 0,
                    bottom: 0,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: UIKit.height(10)),
              child: Text(
                bean.name,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: isChecked
                    ? textTheme.bodyText2.copyWith(fontSize: 12)
                    : textTheme.caption.copyWith(fontSize: 12),
              ),
            ),
            // Offstage(
            //   offstage: !showPrice,
            //   child: Padding(
            //     padding: EdgeInsets.only(top: UIKit.height(10)),
            //     child: Text(
            //       '${bean.price}',
            //       textAlign: TextAlign.center,
            //       style: isChecked
            //           ? textTheme.bodyText2.copyWith(fontSize: 12)
            //           : textTheme.caption.copyWith(fontSize: 12),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonView(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return GestureDetector(
      onTap: callback,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            color: isChecked ? themeData.accentColor : const Color(0xFFEDEDED)),
        margin: EdgeInsets.symmetric(
            horizontal: UIKit.width(10), vertical: UIKit.height(10)),
        padding: EdgeInsets.symmetric(
            horizontal: UIKit.width(15), vertical: UIKit.height(10)),
        child: Text(
          bean.name,
          style: isChecked ? themeData.accentTextTheme.button : TextStyle(),
        ),
      ),
    );
  }
}
