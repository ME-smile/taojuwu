/*
 * @Description: 
 * @Author: iamsmiling
 * @Date: 2020-10-21 18:03:46
 * @LastEditTime: 2020-11-24 14:16:47
 */
extension MapKit on Map {
  dynamic getValueByKey(dynamic key) {
    return this == null ? '' : this[key];
  }
}
