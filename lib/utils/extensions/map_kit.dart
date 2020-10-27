/*
 * @Description: 
 * @Author: iamsmiling
 * @Date: 2020-10-21 18:03:46
 * @LastEditTime: 2020-10-22 09:24:17
 */
extension MapKit on Map {
  dynamic getValueByKey(dynamic key) {
    return this == null ? '' : this[key];
  }
}
