/*
 * @Description: 窗帘 样式  窗型 有无盒 的选择项
 * @Author: iamsmiling
 * @Date: 2020-09-30 15:19:30
 * @LastEditTime: 2020-09-30 15:34:41
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/sku_attr/curtain_sku_attr.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/triangle_clipper.dart';

class WindowStyleOptionView extends StatelessWidget {
  final CurtainStyleOptionAttr attr;
  const WindowStyleOptionView(this.attr, {Key key}) : super(key: key);

  List<StyleOptionAttrBean> get beans => attr.options;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: UIKit.height(20)),
          child: Text(attr.title ?? ''),
        ),
        Row(
          children: List.generate(beans.length, (int index) {
            StyleOptionAttrBean bean = beans[index];
            return Container(
              width: UIKit.width(150),
              height: UIKit.width(150),
              margin: EdgeInsets.only(right: UIKit.width(20)),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(UIKit.getAssetsImagePath(bean.img))),
                  border: Border.all(
                      color: bean.isChecked
                          ? Theme.of(context).accentColor
                          : Colors.grey,
                      width: 2)),
              child: Align(
                alignment: Alignment.bottomRight,
                child: bean.isChecked ? TriAngle() : Container(),
              ),
            );
          }),
        )
      ],
    );
  }
}
