import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:event_bus/event_bus.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_upgrade/flutter_app_upgrade.dart';
import 'package:install_plugin/install_plugin.dart';

import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:taojuwu/utils/toast_kit.dart';

import 'models/app_info/app_info_model.dart';
import 'services/base/cache.dart';
import 'services/otp_service.dart';

class NetworkCacheConfig {
  final bool enable;
  final int maxAge;
  final int maxCount;
  NetworkCacheConfig(
      {this.enable = false, this.maxAge = 1000, this.maxCount = 100});

  Map<String, dynamic> toJson() {
    return {'enable': enable, 'maxAge': maxAge, 'maxCount': maxCount};
  }
}

class Application {
  static Router router;
  static SharedPreferences sp;
  static String deviceInfo;
  static String versionInfo;
  static NetworkCacheConfig cacheConfig = NetworkCacheConfig();
  static NetCache cache = NetCache();
  static RouteObserver routeObserver = RouteObserver();
  static EventBus eventBus = EventBus();
  static const String appName = '淘居屋商家';
  static const String apkName = '淘居屋商家.apk';
  static bool get hasAgree => sp?.getBool('hasAgree') ?? false;
  static AppInfoWrapper appInfo;
  static Future<AppUpgradeInfo> appUpgradeInfo;
  static AppInfoModel appInfoModel;
  static init() async {
    sp = await SharedPreferences.getInstance();
    deviceInfo = await getAppInfo();
  }

  static Future<double> _getTotalSizeOfFilesInDir(
      final FileSystemEntity file) async {
    if (file is File) {
      int length = await file.length();
      return double.parse(length.toString());
    }
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      double total = 0;
      if (children != null)
        for (final FileSystemEntity child in children)
          total += await _getTotalSizeOfFilesInDir(child);
      return total;
    }
    return 0;
  }

  static _renderSize(double value) {
    if (null == value) {
      return 0;
    }
    List<String> unitArr = List()..add('B')..add('K')..add('M')..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }

  ///加载缓存
  static Future<String> loadCache() async {
    Directory tempDir = await getTemporaryDirectory();
    double value = await _getTotalSizeOfFilesInDir(tempDir);
    return Future.value(_renderSize(value));
    /*tempDir.list(followLinks: false,recursive: true).listen((file){
          //打印每个缓存文件的路径
        print(file.path);
      });*/
  }

  static void clearCache() async {
    Directory tempDir = await getTemporaryDirectory();
    //删除缓存目录
    await delDir(tempDir);
    await loadCache();
    ToastKit.showSuccessDIYInfo('清除缓存成功');
  }

  ///递归方式删除目录
  static Future<Null> delDir(FileSystemEntity file) async {
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      for (final FileSystemEntity child in children) {
        await delDir(child);
      }
    }
    await file.delete();
  }

  static Future<String> getAppInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    versionInfo = version;
    List<String> list = [];

    if (Platform.isAndroid) {
      AndroidDeviceInfo appInfo = await deviceInfo.androidInfo;

      list.add('Android');
      list.add(version);
      list.add('${appInfo.model}');
      list.add(appInfo.version.release);
    }
    if (Platform.isIOS) {
      IosDeviceInfo appInfo = await deviceInfo.iosInfo;
      list.add('IOS');
      list.add(version);
      list.add('${appInfo.utsname.machine}');
      list.add(appInfo.systemVersion);
    }
    return list.join(',');
  }

  static Future<String> getRemoteAppVersion() async {
    appInfo = await OTPService.appInfo();
    appInfoModel = appInfo?.appInfoModel;
    appUpgradeInfo = Future.value(appInfo?.appUpgradeInfo);
    return appInfoModel?.version;
  }

  static void checkAppVersion(BuildContext context) async {
    bool hasNewVersion = await hasNewAppVersion();
    if (hasNewVersion) {
      AppUpgrade.appUpgrade(
        context,
        appUpgradeInfo,
        // cancelText: '以后再说',
        okText: '马上升级',
        cancelTextStyle: TextStyle(color: const Color(0xFF2196f3)),
        okTextStyle: TextStyle(color: const Color(0xFF2196f3)),
        okBackgroundColors: [Colors.white, Colors.white],
        progressBarColor: Colors.blue,
        iosAppId: 'id88888888',

        // appMarketInfo: AppMarket.tencent,
        borderRadius: 16.0,
        onCancel: () {
          // print('onCancel');
        },
        onOk: () {
          // print('onOk');
        },
        downloadProgress: (count, total) {
          // print('count:$count,total:$total');
        },
        downloadStatusChange: (DownloadStatus status, {dynamic error}) {
          if (status == DownloadStatus.done) {
            Application.installApk();
          }
        },
      );
    }
  }

  static Future<String> getApkPath() async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }

  static Future<bool> hasNewAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String localVersion = packageInfo.version;

    String remoteVersion = await getRemoteAppVersion();
    remoteVersion = remoteVersion ?? '1.1.0';
    return remoteVersion.compareTo(localVersion) == 1;
  }

  static Future<Null> installApk() async {
    try {
      String path = await getApkPath();

      InstallPlugin.installApk(path + apkName, 'com.buyi.taojuwu')
          .then((_) {})
          .catchError((err) => err);
    } on Error catch (_) {}
  }
}
