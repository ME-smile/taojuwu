/*
 * @Description: cupertino弹窗设置 
 * @Author: iamsmiling
 * @Date: 2020-11-17 17:22:02
 * @LastEditTime: 2020-11-17 17:23:55
 */
import 'package:flutter/cupertino.dart';

class CupertinoLocalizationDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) {
    return DefaultCupertinoLocalizations.load(locale);
  }

  @override
  bool shouldReload(
      covariant LocalizationsDelegate<CupertinoLocalizations> old) {
    return false;
  }
}
