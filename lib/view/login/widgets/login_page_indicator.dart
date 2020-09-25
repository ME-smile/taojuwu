import 'dart:ui';

import 'package:flutter/material.dart';



class LoginPageIndicatorPainter extends CustomPainter {
  final double triangleW;
  final double pointX;
  final double width;

  LoginPageIndicatorPainter({this.triangleW, this.pointX, this.width});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Color(0xff666666)
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(0, 0), Offset(pointX - triangleW, 0), paint);

    canvas.drawLine(
        Offset(pointX - triangleW, 0), Offset(pointX, -triangleW), paint);
    canvas.drawLine(
        Offset(pointX, -triangleW), Offset(pointX + 2 * triangleW, 0), paint);

    canvas.drawLine(Offset(width, 0), Offset(pointX + 2 * triangleW, 0), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
