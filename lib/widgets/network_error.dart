import 'package:flutter/material.dart';

import 'package:taojuwu/utils/ui_kit.dart';

import 'v_spacing.dart';

class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback callback;

  NetworkErrorWidget({@required this.callback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        alignment: Alignment.center,
        height: UIKit.height(200),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.error_outline,
              size: UIKit.sp(80),
            ),
            VSpacing(10),
            Text(
              '点击重新请求',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            )
          ],
        ),
      ),
    );
  }
}
