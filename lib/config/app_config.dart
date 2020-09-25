/*
 * @Description: APP配置
 * @Author: iamsmiling
 * @Date: 2020-08-18 10:18:11
 * @LastEditTime: 2020-09-24 11:19:09
 */

class AppConfig {
  // 是否为生产环境
  static bool isPro = bool.fromEnvironment('dart.vm.product');
  static String get baseUrl =>
      isPro ? 'https://example.com/v1' : 'https://dev.example.com/v1';
}
