import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/utils/ui_kit.dart';

import 'package:taojuwu/widgets/zy_submit_button.dart';

class AfterSaleServicePage extends StatefulWidget {
  AfterSaleServicePage({Key key}) : super(key: key);

  @override
  _AfterSaleServicePageState createState() => _AfterSaleServicePageState();
}

class _AfterSaleServicePageState extends State<AfterSaleServicePage> {
  final List<Map<String, dynamic>> questions = [
    {
      'text': '产品下单错误',
      'type': 1,
      'is_checked': false,
    },
    {
      'text': '结算金额出错',
      'type': 2,
      'is_checked': false,
    },
    {
      'text': '产品残次问题',
      'type': 3,
      'is_checked': false,
    },
    {
      'text': '安装出错',
      'type': 4,
      'is_checked': false,
    },
    {'text': '', 'type': -1, 'is_checked': true}
  ];
  int get checkedType =>
      questions.firstWhere((item) => item['is_checked'] == true)['type'];

  Widget buildQuestioncheckBox() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: UIKit.height(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '您是否遇到:',
            style: TextStyle(fontSize: UIKit.sp(32)),
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: UIKit.width(20), vertical: UIKit.height(30)),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border.all(color: const Color(0xFFCECECE), width: .5)),
            child: ListBody(
              children: List.generate(questions.length - 1, (int i) {
                Map<String, dynamic> item = questions[i];
                return Row(
                  children: <Widget>[
                    Checkbox(
                        value: item['is_checked'],
                        onChanged: (bool flag) {
                          setState(() {
                            if (flag) {
                              for (int j = 0; j < questions.length; j++) {
                                if (j != i) questions[j]['is_checked'] = false;
                              }
                            }
                            item['is_checked'] = flag;
                          });
                        }),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                      child: Text(item['text']),
                    )
                  ],
                );
              }),
            ),
          )
        ],
      ),
    );
  }

  Widget buildQuestionDescBlank() {
    return Container(
      padding: EdgeInsets.symmetric(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '问题描述：',
            style: TextStyle(fontSize: UIKit.sp(32)),
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: UIKit.width(20), vertical: UIKit.height(30)),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border.all(color: const Color(0xFFCECECE), width: .5)),
            child: TextField(),
            height: UIKit.height(160),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('售后维权'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: UIKit.width(40)),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildThankingText(),
              buildQuestioncheckBox(),
              buildQuestionDescBlank(),
              buildUploadImage()
            ],
          ),
        ),
      ),
      bottomNavigationBar: ZYSubmitButton('提交', () {}),
    );
  }

  Widget buildThankingText() {
    return Container(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Text(
              '感谢您选择我们的产品！',
            ),
            Text('我们将及时为您处理并反馈结果！')
          ],
        ));
  }

  List imgList = [];

  var image;

  Future getImageFromFile() async {
    // image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      imgList.add(image);
    });
  }

  Future getImageFromCamera() async {
    // image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      imgList.add(image);
    });
  }

  void pickImage() async {
    await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
              title: const Text('选择图片'),
              actions: <Widget>[
                CupertinoActionSheetAction(
                  child: const Text('相机'),
                  onPressed: () {
                    Navigator.pop(context);
                    getImageFromCamera();
                  },
                ),
                CupertinoActionSheetAction(
                  child: const Text('本地相册'),
                  onPressed: () {
                    Navigator.pop(context);
                    getImageFromFile();
                  },
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                child: const Text('取消'),
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(context);
                },
              ));
        });
  }

  Widget buildUploadImage() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '上传图片',
            style: TextStyle(fontSize: UIKit.sp(32)),
          ),
          Wrap(
            children: <Widget>[
                  InkWell(
                    onTap: () {
                      pickImage();
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: UIKit.width(20),
                          vertical: UIKit.height(20)),
                      child: Icon(
                        ZYIcon.plus,
                        size: UIKit.sp(200),
                      ),
                    ),
                  )
                ] +
                List.generate(imgList?.length ?? 0, (int i) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: UIKit.height(20)),
                    child: Image.file(
                      imgList[i],
                      width: UIKit.sp(200),
                      height: UIKit.sp(200),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
