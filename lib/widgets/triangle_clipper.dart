import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TriAngle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(12, 12), //指定画布大小
      painter: TriAnglePainter(),
    );
  }
}

class TriAnglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;
    Paint paint = Paint()..color = Colors.black;
    Path path = Path();
    path.moveTo(w / 2, h);
    path.lineTo(w, h);
    path.lineTo(w, h / 2);
    path.lineTo(w / 2, h);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
