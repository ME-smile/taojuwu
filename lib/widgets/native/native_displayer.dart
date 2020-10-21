// /*
//  * @Description: 显示原生控件
//  * @Author: iamsmiling
//  * @Date: 2020-10-16 14:46:54
//  * @LastEditTime: 2020-10-16 14:48:32
//  */
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// typedef void UIActivityIndicatorWidgetCreatedCallback(
//     ActivityIndicatorController controller);

// class ActivityIndicatorController {
//   ActivityIndicatorController._(int id)
//       : _channel = MethodChannel('plugins/activity_indicator_$id');

//   final MethodChannel _channel;

//   Future<void> start() async {
//     return _channel.invokeMethod('start');
//   }

//   Future<void> stop() async {
//     return _channel.invokeMethod('stop');
//   }
// }

// class HtmlDisplayer extends StatefulWidget {
//   HtmlDisplayer({Key key}) : super(key: key);

//   @override
//   _HtmlDisplayerState createState() => _HtmlDisplayerState();
// }

// class _HtmlDisplayerState extends State<HtmlDisplayer> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: child,
//     );
//   }
// }
