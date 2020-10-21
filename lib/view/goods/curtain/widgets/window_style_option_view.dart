/*
 * @Description: 窗帘 样式  窗型 有无盒 的选择项
 * @Author: iamsmiling
 * @Date: 2020-09-30 15:19:30
 * @LastEditTime: 2020-10-14 13:55:43
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/sku_attr/window_style_sku_option.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/triangle_clipper.dart';

class WindowStyleOptionView extends StatelessWidget {
  final String title;
  final List<WindowAttrOptionBean> options;
  const WindowStyleOptionView(this.title, {this.options, key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(title ?? ''),
            ),
            Row(
              children: List.generate(options.length, (int index) {
                WindowAttrOptionBean bean = options[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      for (int i = 0; i < options.length; i++) {
                        options[i].isChecked = i == index;
                      }
                    });
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image:
                                AssetImage(UIKit.getAssetsImagePath(bean.img))),
                        border: Border.all(
                            color: bean.isChecked
                                ? Theme.of(context).accentColor
                                : Colors.grey,
                            width: 2)),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: bean.isChecked ? TriAngle() : Container(),
                    ),
                  ),
                );
              }),
            )
          ],
        );
      },
    );
  }
}
