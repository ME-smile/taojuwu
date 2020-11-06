/*
 * @Description: app全量
 * @Author: iamsmiling
 * @Date: 2020-09-25 12:47:45
 * @LastEditTime: 2020-11-04 16:04:52
 */
import 'package:flutter_app_upgrade/flutter_app_upgrade.dart';
import 'package:taojuwu/repository/zy_response.dart';

class AppInfoWrapper {
  final AppInfoModel appInfoModel;
  final AppUpgradeInfo appUpgradeInfo;
  AppInfoWrapper({this.appInfoModel, this.appUpgradeInfo});
}

class AppInfoModelResp extends ZYResponse<AppInfoModel> {
  AppInfoModelResp.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    this.data = this.valid ? AppInfoModel.fromJson(json['data']) : null;
  }
}

class AppInfoModel {
  int id;
  String system;
  String version;
  String title;
  String downloadUrl;
  String log;
  int updateTime;

  AppInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    system = json['app_type'];
    version = json['version_number'];
    title = json['title'];
    downloadUrl = json['download_address'];
    log = json['update_log'];
    updateTime = json['updateTime'];
  }
}
