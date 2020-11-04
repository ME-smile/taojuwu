/*
 * @Description: 网络请求相关配置
 * @Author: iamsmiling
 * @Date: 2020-09-24 12:08:26
 * @LastEditTime: 2020-10-31 14:51:40
 */

import '../application.dart';

class NetConfig {
  //为测试环境和生产环境配置不同的url
  static String get baseUrl => const bool.fromEnvironment('dart.vm.product')
      ? 'http://106.14.219.213:8001'
      : 'http://106.14.219.213:8001';

  //请求头-->每个请求都会携带
  static final Map<String, String> headers = {
    'ACCEPT': 'application/json',
    'equipment': Application.deviceInfo
  };
  //token信息-->每个请求都会携带
  static final Map<String, dynamic> queryParameters = {
    'token': Application.token,
  };

  //请求过期时间
  static const int TIME_OUT = 5000;
}
