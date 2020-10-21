/*
 * @Description: 风格标签
 * @Author: iamsmiling
 * @Date: 2020-10-12 17:16:19
 * @LastEditTime: 2020-10-16 11:05:45
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/config/text_style/taojuwu_text_style.dart';
import 'package:taojuwu/providers/theme_provider.dart';

class StyleTag extends StatelessWidget {
  final String text;
  const StyleTag(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12, bottom: 12, right: 8),
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      decoration: BoxDecoration(
          color: TaojuwuColors.LIGHT_YELLOW_COLOR,
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          CircleAvatar(
            radius: 8,
            backgroundColor: TaojuwuColors.DEEP_YELLOW_COLOR,
            child: Text(
              '#',
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),

          Container(
            margin: EdgeInsets.only(left: 8),
            child: Text(
              text ?? '',
              style: TaojuwuTextStyle.YELLOW_TEXT_STYLE,
            ),
          )
          // Padding(padding: null)
        ],
      ),
    );
  }
}
