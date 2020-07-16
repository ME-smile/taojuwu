import 'package:flutter/material.dart';

class TriAngleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;
    print(w);
    print('宽------$w------$h');
    Path path = Path();
    // 从 60，0 开始
    path.moveTo(w / 2, 0);
    // 二阶贝塞尔曲线画弧

    // 连接到底部
    path.lineTo(w / 2, h / 2);
    path.lineTo(w / 2, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TriAnglePainter extends CustomPainter {
  TriAnglePainter();

  Paint _paint = Paint()
    ..color = Colors.black
    ..strokeWidth = 4.0
    ..style = PaintingStyle.stroke
    ..strokeJoin = StrokeJoin.round;

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    double w = size.width;
    double h = size.height;
    path.moveTo(h, 0);
    path.lineTo(w, h / 2);
    canvas.drawLine(Offset(h, w / 2), Offset(w, h / 2), _paint);
  }

  @override
  bool shouldRepaint(TriAnglePainter oldDelegate) {
    return false;
  }
}
