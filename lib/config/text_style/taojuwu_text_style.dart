/*
 * @Description: 字体样式
 * @Author: iamsmiling
 * @Date: 2020-10-10 16:19:39
 * @LastEditTime: 2020-10-13 15:44:47
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/providers/theme_provider.dart';

class TaojuwuTextStyle {
  // 强调文字 字体样式 加粗
  static const TextStyle EMPHASIS_TEXT_STYLE_BOLD = TextStyle(
      color: TaojuwuColors.EMPHASIS_TEXT_COLOR,
      fontSize: 14,
      fontWeight: FontWeight.bold);

  // 强调文字 字体样式 不加粗
  static const TextStyle EMPHASIS_TEXT_STYLE = TextStyle(
    color: TaojuwuColors.EMPHASIS_TEXT_COLOR,
    fontSize: 14,
  );

  // 描述性文字常用字体
  static const TextStyle SUB_TEXT_STYLE =
      TextStyle(fontSize: 12, color: TaojuwuColors.SUB_COLOR);

  //红色字体
  static const TextStyle RED_TEXT_STYLE = TextStyle(
      color: TaojuwuColors.RED_COLOR,
      fontSize: 18,
      fontWeight: FontWeight.bold);

  static const TextStyle WHITE_TEXT_STYLE = TextStyle(
      color: TaojuwuColors.WHITE_COLOR,
      fontSize: 14,
      fontWeight: FontWeight.w600);

  //普通文字
  static const SUB_TITLE_TEXT_STYLE = TextStyle(
      fontSize: 16,
      color: TaojuwuColors.SUB_TITLE_COLOR,
      fontWeight: FontWeight.normal);
  // tag
  static const YELLOW_TEXT_STYLE =
      TextStyle(fontSize: 12, color: TaojuwuColors.YELLOW_COLOR);

  static const TITLE_TEXT_STYLE = TextStyle(
      color: TaojuwuColors.EMPHASIS_TEXT_COLOR,
      fontSize: 16,
      fontWeight: FontWeight.bold);

  // 灰色字体 市场价
  static const GREY_TEXT_STYLE =
      TextStyle(color: TaojuwuColors.GREY_COLOR, fontSize: 12);
}
