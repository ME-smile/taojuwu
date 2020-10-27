/*
 * @Description: 对象上的扩展方法
 * @Author: iamsmiling
 * @Date: 2020-10-23 09:28:06
 * @LastEditTime: 2020-10-26 14:49:20
 */
extension CommonKit on Object {
  bool isNullOrEmpty(var variable) {
    if (variable == null) return true;
    if (variable is String ||
        variable is Map ||
        variable is Set ||
        variable is List) return variable.isEmpty;
    return false;
  }
}
