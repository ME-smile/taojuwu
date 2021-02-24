import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taojuwu/application.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/repository/zy_response.dart';
import 'package:taojuwu/services/api_path.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/toast_kit.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:http_parser/http_parser.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:taojuwu/widgets/zy_photo_view.dart';
import 'package:taojuwu/widgets/zy_submit_button.dart';

class AfterSaleServicePage extends StatefulWidget {
  final int id;
  AfterSaleServicePage({Key key, @required this.id}) : super(key: key);

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

  String description;

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
            padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
            margin: EdgeInsets.symmetric(
                horizontal: UIKit.width(20), vertical: UIKit.height(30)),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border.all(color: const Color(0xFFCECECE), width: .5)),
            child: TextField(
              onChanged: (String val) {
                description = val;
              },
              decoration: InputDecoration(hintText: "请对您遇到的问题进行描述"),
            ),
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
          color: Theme.of(context).primaryColor,
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
      bottomNavigationBar: Container(
        color: Theme.of(context).primaryColor,
        child: ZYSubmitButton('提交', submit),
      ),
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

  List<String> imgList = [];

  List<Asset> images = [];

  File image;

  Future getImageFromFile() async {
    try {
      images = await MultiImagePicker.pickImages(
        maxImages: 9,
        enableCamera: true,
        materialOptions: MaterialOptions(
            // 显示所有照片，值为 false 时显示相册
            startInAllView: true,
            allViewTitle: '所有照片',
            actionBarColor: '#2196F3',
            textOnNothingSelected: '没有选择照片'),
      );

      images.forEach((e) async {
        ByteData byteData = await e.getByteData();
        List<int> imageData = byteData.buffer.asUint8List();
        String suffix =
            e.name.substring(e.name.lastIndexOf(".") + 1, e.name.length);
        MultipartFile multipartFile = MultipartFile.fromBytes(imageData,
            filename: e.name, contentType: MediaType("image", suffix));
        FormData formData = FormData.fromMap({"file_path": multipartFile});
        print("上传土坯");

        Response response = await Dio().post(ApiPath.HOST + ApiPath.uploadImg,
            queryParameters: {
              "token": Application.sp.getString('token'),
              "file_path": e.name
            },
            data: formData,
            options: Options(responseType: ResponseType.plain));
        Map json = jsonDecode(response.data ?? "{}");
        if (json != null && json["code"] == 0) {
          String path = UIKit.getNetworkImgPath(json["data"]["data"]);
          setState(() {
            imgList.add(path);
          });
        }
      });

      // image = await ImagePicker.pickImage(source: ImageSource.gallery);
      // setState(() {
      //   imgList.add(image);
      // });
    } catch (err) {
      ToastKit.showErrorInfo("从相册获取图片失败!");
    }
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
                  child: const Text('从相册中选择图片'),
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
                    onTap: pickImage,
                    child: Container(
                        width: UIKit.sp(196),
                        height: UIKit.sp(196),
                        color: Color(0xFFEBECEE).withAlpha(120),
                        margin: EdgeInsets.symmetric(
                            horizontal: UIKit.width(20),
                            vertical: UIKit.height(20)),
                        child: Container(
                            margin: EdgeInsets.all(UIKit.sp(36)),
                            width: UIKit.sp(48),
                            height: UIKit.sp(48),
                            child: Image.asset(
                              UIKit.getAssetsImagePath("upload.png"),
                              color: Color(0xFFEBECEE).withOpacity(0.9),
                              fit: BoxFit.fitWidth,
                            ))),
                  )
                ] +
                List.generate(imgList?.length ?? 0, (int i) {
                  return Container(
                    height: UIKit.sp(196),
                    width: UIKit.sp(196),
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              right: UIKit.height(16), left: UIKit.height(16)),
                          // child: Image.network(
                          //   imgList[i],
                          //   width: UIKit.sp(200),
                          //   height: UIKit.sp(200),
                          // ),
                          child: ZYPhotoView(
                            imgList[i],
                            fit: BoxFit.fill,
                          ),
                        ),
                        Positioned(
                            right: 0,
                            top: 0,
                            child: GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                      color: Colors.black54),
                                  child: Icon(
                                    ZYIcon.close,
                                    size: 16,
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    imgList.removeAt(i);
                                  });
                                }))
                      ],
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }

  submit() {
    return OTPService.aftersell(params: {
      "picture": imgList.join(","),
      "order_id": widget.id,
      "type": checkedType,
      "description": description
    }).then((ZYResponse response) {
      ToastKit.showInfo(response.message);
      if (response.valid) {
        Navigator.of(context).pop();
      }
    });
  }
}
