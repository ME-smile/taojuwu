/*
 * @Description: 主题 颜色 字体相关配置
 * @Author: iamsmiling
 * @Date: 2020-09-25 12:47:45
 * @LastEditTime: 2020-10-14 14:53:51
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool isDarkMode = false;
  static const String FONT_FAMILY = 'Quicksand';
  static ThemeData lightTheme = ThemeData(
    // primaryTextTheme: TextTheme(
    //   body1:const TextStyle(color: TaojuwuColors.ACCENT_TEXT_COLOR),
    //       title:const TextStyle(color: TaojuwuColors.ACCENT_TEXT_COLOR),
    //       subtitle:const  TextStyle(color: TaojuwuColors.ACCENT_TEXT_COLOR),
    //       caption:const TextStyle(color: TaojuwuColors.ACCENT_TEXT_COLOR),
    // ),
    primaryColor: Colors.white,

    scaffoldBackgroundColor: TaojuwuColors.SCAFFOLD_BG_COLOR,

    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    // fontFamily: FONT_FAMILY,
    indicatorColor: TaojuwuColors.INDICATOR_COLOR,
    toggleableActiveColor: TaojuwuColors.TOGGLE_ACTIVE_COLOR,
    iconTheme: IconThemeData(color: TaojuwuColors.ICON_COLOR),
    accentIconTheme: IconThemeData(color: TaojuwuColors.ACCENT_ICON_COLOR),
    dividerTheme: DividerThemeData(color: TaojuwuColors.DIVIDER_COLOR),
    appBarTheme: AppBarTheme(
      elevation: .5,
    ),
    accentColor: TaojuwuColors.ACCENT_COLOR,
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(color: TaojuwuColors.HINT_TEXT_COLOR),
      labelStyle: TextStyle(color: TaojuwuColors.LABEL_TEXT_COLOR),
      enabledBorder: InputBorder.none,
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent, width: 0),
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent, width: 0),
      ),
    ),
    accentTextTheme: TextTheme(
      bodyText2: const TextStyle(color: TaojuwuColors.ACCENT_TEXT_COLOR),
      headline6: const TextStyle(color: TaojuwuColors.ACCENT_TEXT_COLOR),
      subtitle2: const TextStyle(color: TaojuwuColors.ACCENT_TEXT_COLOR),
      caption: const TextStyle(color: TaojuwuColors.ACCENT_TEXT_COLOR),
    ),
    disabledColor: TaojuwuColors.DISABLED_COLOR,

    buttonTheme: ButtonThemeData(
      textTheme: ButtonTextTheme.normal,
      buttonColor: TaojuwuColors.BUTTON_BG_COLOR,
      disabledColor: TaojuwuColors.DISABLED_COLOR,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
    ),
    buttonColor: TaojuwuColors.BUTTON_BG_COLOR,
    // cupertinoOverrideTheme: CupertinoThemeData(primaryColor: Colors.white),
    brightness: Brightness.light,
    textTheme: TextTheme(
        headline5: TextStyle(
            color: TaojuwuColors.HEADLINE_COLOR, fontWeight: FontWeight.w600),
        headline6: TextStyle(color: TaojuwuColors.TITLE_COLOR),
        subtitle2: TextStyle(color: TaojuwuColors.SUBTITLE_COLOR),
        button: TextStyle(color: TaojuwuColors.BUTTON_COLOR),
        subtitle1: TextStyle(color: TaojuwuColors.SUBHEAD_COLOR),
        bodyText2: TextStyle(color: TaojuwuColors.BODY1_COLOR),
        bodyText1: TextStyle(color: TaojuwuColors.BODY2_COLOR),
        caption: TextStyle(color: TaojuwuColors.CAPTION_COLOR)),
  );
}

class TaojuwuColors {
  static const Color HEADLINE_COLOR = Color(0xFF2E2E2E);
  static const Color TITLE_COLOR = Color(0xFF1B1B1B);
  static const Color SUBTITLE_COLOR = Color(0xFF898989);
  static const Color BUTTON_COLOR = Colors.white;
  static const Color SUBHEAD_COLOR = Color(0xFF4A4A4A);
  static const Color BODY1_COLOR = Color(0xFF050505);
  static const Color BODY2_COLOR = Colors.black;
  static const Color CAPTION_COLOR = Color(0xFF999999);
  static const Color BUTTON_BG_COLOR = Color(0xFF171717);
  static const Color INDICATOR_COLOR = Color(0xFF0C0C0C);
  static const Color TOGGLE_ACTIVE_COLOR = Color(0xFF2B2B2B);
  static const Color ICON_COLOR = Color(0xFFCCCCCC);
  static const Color ACCENT_ICON_COLOR = Color(0xFF2D2D2D);
  static const Color DIVIDER_COLOR = Color(0xFFEAEAEA);
  static const Color BORDER_COLOR = Color(0xFFC7C8CB);
  static const Color HINT_TEXT_COLOR = BORDER_COLOR;
  static const Color LABEL_TEXT_COLOR = Color(0xFF2E2E2E);
  static const Color ACCENT_TEXT_COLOR = Colors.white;
  static const Color ACCENT_COLOR = Color(0xFF171717);
  static const Color SCAFFOLD_BG_COLOR = Color(0xFFF8F8F8);
  static const Color DISABLED_COLOR = Colors.grey;

  static const Color EMPHASIS_TEXT_COLOR = Color(0xFF1B1B1B);
  static const Color SUB_COLOR = Color(0xFF6D6D6D);

  //红色
  static const Color RED_COLOR = Color(0xFFFF6161);

  //白色
  static const Color WHITE_COLOR = Colors.white;

  //浅黄色
  static const Color LIGHT_YELLOW_COLOR = Color(0xFFFCF3E8);
  //深黄色
  static const Color DEEP_YELLOW_COLOR = Color(0xFFFFB861);

  //黄色
  static const Color YELLOW_COLOR = Color(0xFFFFB861);

  // 副标题颜色
  static const Color SUB_TITLE_COLOR = Color(0xFF444444);

  //浅灰色
  static const Color LIGHT_GREY_COLOR = Color(0xFFF7F7FA);

  // 灰色
  static const Color GREY_COLOR = Color(0xFF999999);

  //
  // static const Color ACCENT_BUTTON_BORDER = Color(0xFF2B2B2B);
}
