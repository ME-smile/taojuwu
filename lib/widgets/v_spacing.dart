import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VSpacing extends StatelessWidget {
  final int height;
  const VSpacing(this.height);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenUtil().setHeight(height),
    );
  }
}
