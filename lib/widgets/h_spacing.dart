import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HSpacing extends StatelessWidget {
  final int width;
  const HSpacing(this.width);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenUtil().setWidth(width),
    );
  }
}
