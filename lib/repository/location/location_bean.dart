/*
 * @Description: //地理位置信息模型
 * @Author: iamsmiling
 * @Date: 2020-11-11 11:08:41
 * @LastEditTime: 2020-11-18 17:39:06
 */
class LocationBean {
  String country;
  String province;
  String city;
  String district;
  String townShip;
  String townCode;
  Map<String, dynamic> data;
  LocationBean.fromJson(Map<String, dynamic> json) {
    data = json;
    country = '${json['nation']}';
    province = '${json['province']}';
    city = '${json['city']}';
    district = '${json['district']}';
    townShip = '${json['township']}';
    // townCode = '${json['towncode']}';
  }
}
