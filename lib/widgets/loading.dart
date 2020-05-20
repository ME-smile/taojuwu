import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingCircle extends StatelessWidget {
  const LoadingCircle({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      // height: MediaQuery.of(context).size.height,
      child: SpinKitCircle(
        color: Color(0xffcccccc),
        size: 50,
      ),
    );
  }
}
