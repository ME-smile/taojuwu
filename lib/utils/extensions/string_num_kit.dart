/*
 * @Description: 字符串解析为数字相关的函数
 * @Author: iamsmiling
 * @Date: 2020-10-20 10:51:02
 * @LastEditTime: 2020-10-20 10:57:20
 */
extension ParseNumKit on String {
  //是否为null or 0
  bool isNumNullOrZero(num n) {
    if (n == null) return true;
    if (n == 0) return true;
    return false;
  }

  //是否为数字字符串
  bool isNumString(String str) {
    RegExp re = new RegExp(r"^[0-9]{1,}[.]?[0-9]*$");
    return re.hasMatch(str);
  }

  //将变量解析为int
  int parseInt(var variable, {int defaultVal = -1}) {
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

  //将变量解析为double
  double parseDouble(var variable, {double defaultVal = -1.0}) {
    if (variable == null) return defaultVal;
    if (variable is int) return variable.toDouble();
    if (variable is double) return variable;
    if (variable is String) {
      variable = variable.trim(); //去除左右两端空格
      // 如果字符为空或者不是出数字则返回-1
      if (variable.isEmpty || !isNumString(variable)) return defaultVal;
      return double.parse(variable);
    }
    return defaultVal;
  }
}
