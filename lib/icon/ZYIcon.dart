import 'package:flutter/material.dart';
class ZYIcon{
  static const Icon prev = Icon(_ZYIcon(0xe643));
  static const Icon cart = Icon(_ZYIcon(0xe67c));

  static const Icon del = Icon(_ZYIcon(0xe644));
  static const Icon search = Icon(_ZYIcon(0xe64a));
  static const Icon add = Icon(_ZYIcon(0xe64d),color: const Color(0xFF171717),);
  static const Icon plus = Icon(_ZYIcon(0xe602));
  static const Icon substract = Icon(_ZYIcon(0xe676));

  static const Icon drop_down = Icon(_ZYIcon(0xe604));
  static const Icon close = Icon(_ZYIcon(0xe60a));
  static const Icon eye_close = Icon(_ZYIcon(0xe627));

  static const Icon scan = Icon(_ZYIcon(0xe606));
  static const Icon check = Icon(_ZYIcon(0xe6e5));
  static const Icon user_add = Icon(_ZYIcon(0xe64b));
  static const Icon like = Icon(_ZYIcon(0xe79d),color: Colors.red,);
  static const Icon unlike = Icon(_ZYIcon(0xe79d),);
  static const Icon tel_book = Icon(_ZYIcon(0xe667));

  static const Icon eye = Icon(_ZYIcon(0xe63c));
  static const Icon edit = Icon(_ZYIcon(0xe657));
  static const Icon checked = Icon(_ZYIcon(0xe7ba));

  static const Icon filter = Icon(_ZYIcon(0xe8ec));
  static const Icon next = Icon(_ZYIcon(0xe6a2));
  static const Icon disabled = Icon(_ZYIcon(0xe706));
  static const Icon share = Icon(_ZYIcon(0xe999));
  static const Icon fill_checked = Icon(_ZYIcon(0xe7d3));
    
  static const Icon user =Icon(_ZYIcon(0xe67b));
  static const Icon dot = Icon(_ZYIcon(0xe63f),color: const Color(0xFF6ABD13),size: 16,);
}

class _ZYIcon extends IconData{
   final String fontFamily;
  const _ZYIcon(int codePoint,{this.fontFamily='Taojuwu'}) : super(codePoint);
}