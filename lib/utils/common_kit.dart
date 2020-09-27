/*
 * @Description:  常用工具函数的封装
 * @Author: iamsmiling
 * @Date: 2020-08-03 10:46:13
 * @LastEditTime: 2020-09-25 16:41:59
 */
import 'dart:async';

import 'dart:math';

class CommonKit {
  static Function debounce(Function callback, [int delay = 300]) {
    Timer _debounce;
    Function fn = () {
      if (_debounce?.isActive ?? false) _debounce.cancel();
      _debounce = Timer(Duration(milliseconds: delay), () {
        callback();
      });
    };
    return fn();
  }

  static String getRandomStr({int length: 30}) {
    String alphabet = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
    String str = '';
    for (int i = 0; i < length; i++) {
//    right = right + (min + (Random().nextInt(max - min))).toString();
      str = str + alphabet[Random().nextInt(alphabet.length)];
    }
    return str;
  }

  /*
    * @Author: iamsmiling
    * @description: 判断字符串是否为纯数字
    * @param : string
    * @return bool
    * @Date: 2020-09-24 13:14:03
    */

  /*
   * @Author: iamsmiling
   * @description: 将变量解析为数字并返回
   * @param : string
   * @return int 
   * @Date: 2020-09-24 13:08:57 
   */
  static int parseInt(var variable, {int defaultVal = -1}) {
    // 判断是否为空
    if (variable == null) return defaultVal;
    // 判断是否为字符串
    if (variable.runtimeType == int) return variable;
    // 判断是为字符串
    if (variable.runtimeType == String) {
      variable = variable.trim(); //去除左右两端空格
      // 如果字符为空或者不是出数字则返回-1
      if (variable.isEmpty || !isNumString(variable)) return defaultVal;
      return int.parse(variable);
    }
    return defaultVal;
  }

  static double parseDouble(var variable, {double defaultVal = -1.0}) {
    if (variable == null) return defaultVal;
    if (variable.runtimeType == int) return variable;
    if (variable.runtimeType == String) {
      variable = variable.trim(); //去除左右两端空格
      // 如果字符为空或者不是出数字则返回-1
      if (variable.isEmpty || !isNumString(variable)) return defaultVal;
      return double.parse(variable);
    }
    return defaultVal;
  }

  static bool isNullOrEmpty(var variable) {
    return variable == null || variable.isEmpty;
  }

  /*
 * @Author: iamsmiling
 * @description: 生成随机字符串
 * @param : lenght -->目标字符串的长度
 * @return string 
 * @Date: 2020-09-24 13:10:03
 */
  static bool isNumString(String str) {
    RegExp re = new RegExp(r"^[0-9]{1,}[.][0-9]*$");
    return re.hasMatch(str);
  }

  /*
   * @Author: iamsmiling
   * @description: 固定小数位数，默认保留两位小数
   * @param : n == 需要保留的目标数字 digits =>目标精度，默认为2
   * @return double
   * @Date: 2020-09-27 09:52:17
   */
  static double toDoubleAsFixed(double n, {double digits = 2}) {
    return double.parse(n.toStringAsPrecision(2));
  }
}
