/*
 * @Description: 数字相关方法拓展
 * @Author: iamsmiling
 * @Date: 2020-10-26 14:33:50
 * @LastEditTime: 2020-10-27 18:00:53
 */
extension NumKit on num {
  bool isNullOrZero(var variable) {
    return variable == null || variable == 0;
  }

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

  bool isNumString(String str) {
    RegExp re = new RegExp(r"^[0-9]{1,}[.]?[0-9]*$");
    return re.hasMatch(str);
  }
}
