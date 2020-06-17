import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taojuwu/constants/constants.dart';

class UIKit {
  //底部弹宽统一设置
  static const double BOTTOM_PICKER_HEIGHT = 300;

  //取消按钮字体
  static const TextStyle CANCEL_BUTTON_STYLE =
      TextStyle(color: Colors.grey, fontSize: 18);

  //确认按钮字体
  static const TextStyle CONFIRM_BUTTON_STYLE =
      TextStyle(color: const Color(0xFF2196f3), fontSize: 18);

  //标题字体
  static const TextStyle TITLE_STYLE =
      TextStyle(color: const Color(0xFF333333), fontSize: 18);
  // 选项按钮字体
  static const TextStyle OPTION_ITEM_STYLE =
      TextStyle(color: Colors.black, fontSize: 20);

  //选项高度
  static const double ITEM_EXTENT = 48;

  static double sp(double fontSize) {
    return ScreenUtil().setSp(fontSize);
  }

  static double width(double width) {
    return ScreenUtil().setWidth(width);
  }

  static double height(double height) {
    return ScreenUtil().setHeight(height);
  }

  static const String IMAGE_DIR = 'assets/images';

  static String getAssetsImagePath(String path) {
    return '$IMAGE_DIR/$path';
  }

  static String getNetworkImgPath(String path) {
    return path?.contains('http') == true ? path : '${Constants.HOST}/$path';
  }

  static String getGreetWord(DateTime time) {
    // 6-12 上午好 // 12-18 下午好
    int h = time.hour + 1;
    if (6 < h && h < 13) return '上午好';
    if (13 <= h && h < 19) return '下午好';
    return '晚上好';
  }

  static String getTimeStr(var milliSeconds) {
    var time = milliSeconds;
    if (time is num) {
      time = time * 1000;
    } else {
      time = 0;
    }
    return DateUtil.formatDateMs(time ?? 0,
            isUtc: false, format: 'yyyy-MM-dd HH:mm:ss') ??
        '';
  }
}
