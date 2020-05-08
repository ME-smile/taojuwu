import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class CommonKit {
  static void toast(BuildContext context, String msg) {
    Toast.show(
      msg ?? '',
      context,
      duration: Toast.LENGTH_SHORT,
      gravity: Toast.CENTER,
      backgroundColor: Color(0xEE888888),
      textColor: Colors.white,
      backgroundRadius: 5
    );
  }

  static Function debounce(Function callback, [int delay = 300]) {
    Timer _debounce;
    Function fn = () {
      if (_debounce?.isActive ?? false) _debounce.cancel();
      _debounce = Timer(Duration(milliseconds: delay), () {
        callback();
      });
    };
    return fn();
  }
}

// fluro 参数编码解码工具类
class FluroConvertUtils {
  /// fluro 传递中文参数前，先转换，fluro 不支持中文传递
  static String fluroCnParamsEncode(String originalCn) {
    return jsonEncode(Utf8Encoder().convert(originalCn));
  }

  /// fluro 传递后取出参数，解析
  static String fluroCnParamsDecode(String encodeCn) {
    var list = List<int>();

    ///字符串解码
    jsonDecode(encodeCn).forEach(list.add);
    String value = Utf8Decoder().convert(list);
    return value;
  }

  /// string 转为 int
  static int string2int(String str) {
    return int.parse(str);
  }

  /// string 转为 double
  static double string2double(String str) {
    return double.parse(str);
  }

  /// string 转为 bool
  static bool string2bool(String str) {
    if (str == 'true') {
      return true;
    } else {
      return false;
    }
  }

  /// object 转为 string json
  static String object2string<T>(T t) {
    return fluroCnParamsEncode(jsonEncode(t));
  }

  /// string json 转为 map
  static Map<String, dynamic> string2map(String str) {
    return json.decode(fluroCnParamsDecode(str));
  }
}
