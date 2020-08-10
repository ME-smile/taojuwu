import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingCircle extends StatelessWidget {
  final Color color;
  const LoadingCircle({Key key, this.color = Colors.white}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      color: color,
      alignment: Alignment.center,
      // height: MediaQuery.of(context).size.height,
      child: SpinKitCircle(
        color: Color(0xffcccccc),
        size: 50,
      ),
    );
  }
}
