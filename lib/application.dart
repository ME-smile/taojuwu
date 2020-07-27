import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:taojuwu/utils/common_kit.dart';

class Application {
  static Router router;
  static SharedPreferences sp;
  static String deviceInfo;
  static String versionInfo;
  static RouteObserver routeObserver = RouteObserver();
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
    CommonKit.showSuccessDIYInfo('清除缓存成功');
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
}
