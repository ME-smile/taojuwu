import 'package:flutter/material.dart';
import 'package:taojuwu/models/zy_response.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/zy_submit_button.dart';

class FeedbackPage extends StatefulWidget {
  FeedbackPage({Key key}) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  TextEditingController questionInput;
  TextEditingController telInput;

  @override
  void initState() {
    super.initState();
    questionInput = TextEditingController();
    telInput = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    questionInput?.dispose();
    telInput?.dispose();
  }

  String content;
  String tel;
  bool beforeSendData() {
    content = questionInput?.text?.trim();
    tel = telInput?.text?.trim();
    if (content?.isNotEmpty != true) {
      CommonKit.showInfo('反馈信息不能为空哦');
      return false;
    }
    if (tel?.isNotEmpty != true) {
      CommonKit.showInfo('请填写正确的联系方式哦');
      return false;
    }
    return true;
  }

  void feedback() {
    if (beforeSendData() == false) return;
    OTPService.feedback(params: {
      'consult_content': content,
      'consult_contact': tel,
    }).then((ZYResponse response) {
      if (response?.valid == true) {
        Navigator.of(context).pop();
      }
    }).catchError((err) => err);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('问题反馈'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: GestureDetector(
        child: Container(
          color: themeData.primaryColor,
          width: double.infinity,
          margin: EdgeInsets.only(top: UIKit.height(20)),
          padding: EdgeInsets.symmetric(
              horizontal: UIKit.width(20), vertical: UIKit.height(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '问题反馈',
                style: textTheme.title,
              ),
              Container(
                height: UIKit.height(320),
                margin: EdgeInsets.symmetric(vertical: UIKit.height(20)),
                padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                decoration: BoxDecoration(
                    border: Border.all(color: themeData.dividerColor),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: TextField(
                  controller: questionInput,
                  maxLines: 99,
                  decoration: InputDecoration(
                    hintText: '请描述您的问题和意见，感谢支持',
                    border: InputBorder.none,
                  ),
                ),
              ),
              Text(
                '联系方式',
                style: textTheme.title,
              ),
              Container(
                // alignment: Alignment.center,
                height: UIKit.height(120),
                margin: EdgeInsets.symmetric(vertical: UIKit.height(20)),
                padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                decoration: BoxDecoration(
                    border: Border.all(color: themeData.dividerColor),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: TextField(
                  controller: telInput,
                  maxLines: 99,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: '请留下您的手机号、微信或者邮箱，以便我们联系您',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
      bottomNavigationBar: ZYSubmitButton('提交反馈', () {
        feedback();
      }),
    );
  }
}
