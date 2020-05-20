import 'package:flutter/material.dart';

class ZYIcon {
  static const IconData prev = ZYIconData(0xe643);

  static const IconData cart = ZYIconData(0xe67c);

  static const IconData del = ZYIconData(0xe644);

  static const IconData clear = ZYIconData(0xe65e);
  static const IconData plus_blank = ZYIconData(0xe693);
  static const IconData plus_full = ZYIconData(0xe6bd);
  static const IconData sub_blank = ZYIconData(0xe67a);
  static const IconData sub_full = ZYIconData(0xe678);
  static const IconData search = ZYIconData(0xe64a);
  static const IconData add = ZYIconData(0xe64d);
  static const IconData plus = ZYIconData(0xe602);
  static const IconData substract = ZYIconData(0xe676);

  static const IconData drop_down = ZYIconData(0xe604);
  static const IconData close = ZYIconData(0xe60a);
  static const IconData eye_close = ZYIconData(0xe627);

  static const IconData scan = ZYIconData(0xe606);
  static const IconData check = ZYIconData(0xe6e5);
  static const IconData user_add = ZYIconData(0xe64b);
  static const IconData like = ZYIconData(0xe79d);
  static const IconData tel_book = ZYIconData(0xe667);

  static const IconData eye = ZYIconData(0xe63c);
  static const IconData edit = ZYIconData(0xe657);
  static const IconData checked = ZYIconData(0xe7ba);

  static const IconData filter = ZYIconData(0xe8ec);
  static const IconData next = ZYIconData(0xe6a2);
  static const IconData disabled = ZYIconData(0xe706);
  static const IconData share = ZYIconData(0xe999);
  static const IconData fill_checked = ZYIconData(0xe7d3);

  static const IconData user = ZYIconData(0xe67b);
  static const IconData dot = ZYIconData(0xe63f);
  static const IconData exclamation_point = ZYIconData(0xe670);
  static const IconData exclamation_point_fill = ZYIconData(0xe860);
}

class ZYIconData extends IconData {
  final String fontFamily;
  const ZYIconData(int codePoint, {this.fontFamily = 'Taojuwu'})
      : super(codePoint);
}
