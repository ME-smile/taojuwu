
import 'dart:async';

import 'package:flutter/services.dart';

class AmapLocator {
  static const MethodChannel _channel =
      const MethodChannel('amap_locator');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
