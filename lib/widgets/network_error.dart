/*
 * @Description: 网络错误
 * @Author: iamsmiling
 * @Date: 2020-09-25 12:47:45
 * @LastEditTime: 2020-11-19 19:13:39
 */
import 'package:flutter/material.dart';

import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/zy_assetImage.dart';

import 'v_spacing.dart';

class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback callback;

  NetworkErrorWidget({@required this.callback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Material(
          child: Container(
        alignment: Alignment.center,
        height: double.maxFinite,
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ZYAssetImage(
              'net_error@2x.png',
              width: UIKit.width(250),
              height: UIKit.width(250),
              callback: callback,
            ),
            VSpacing(10),
            Text(
              '点击重新请求',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            )
          ],
        ),
      )),
    );
  }
}
