import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:taojuwu/models/protocal/user_protocal_model.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/zy_future_builder.dart';

class UserProtocalPage extends StatefulWidget {
  UserProtocalPage({Key key}) : super(key: key);

  @override
  _UserProtocalPageState createState() => _UserProtocalPageState();
}

class _UserProtocalPageState extends State<UserProtocalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('用户协议'),
      ),
      body: ZYFutureBuilder(
          futureFunc: OTPService.protocal,
          builder: (BuildContext context, UserProtocalModelResp response) {
            String content = response?.data?.content ?? '';

            return Container(
              padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
              child: SingleChildScrollView(
                child: Html(data: content),
              ),
            );
          }),
    );
  }
}
