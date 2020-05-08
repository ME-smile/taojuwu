import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taojuwu/constants/constants.dart';

class UIKit {
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
    return path.contains('http') ? path : '${Constants.HOST}/$path';
  }


  static String getGreetWord(DateTime time){
    // 6-12 上午好 // 12-18 下午好 
    int h = time.hour+1;
    if(6<h && h<13) return '上午好';
    if(13<=h && h<19) return '下午好';
    return '晚上好';
  }

  
}
