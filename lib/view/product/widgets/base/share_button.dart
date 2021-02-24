/*
 * @Description: 分享按钮
 * @Author: iamsmiling
 * @Date: 2021-01-25 11:33:39
 * @LastEditTime: 2021-02-23 18:05:21
 */
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluwx/fluwx.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/repository/zy_response.dart';
import 'package:taojuwu/services/api_path.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/net_kit.dart';
import 'package:taojuwu/utils/toast_kit.dart';
import 'package:taojuwu/utils/ui_kit.dart';

class XShareModel {
  String description;
  String icon;
  Function onTap;
  XShareModel({this.description, this.icon, this.onTap});
}

class ShareButton extends StatefulWidget {
  final int id;
  ShareButton({Key key, @required this.id}) : super(key: key);

  @override
  _ShareButtonState createState() => _ShareButtonState();
}

class TaojuwuShareModel {
  WeChatShareWebPageModel sessionShareModel;
  WeChatShareWebPageModel momentShareModel;
  WeChatImage weChatImage;
  String url;
  String copyTip;

  TaojuwuShareModel(
      {@required this.sessionShareModel,
      @required this.momentShareModel,
      @required this.url,
      @required this.weChatImage,
      this.copyTip = "链接复制成功"});

  TaojuwuShareModel.fromJson(Map json) {
    url = json["url"];
    String description = json["others_title"];
    String title = json["title"];

    weChatImage = json["img"];
    sessionShareModel = WeChatShareWebPageModel(url,
        thumbnail: weChatImage,
        description: description,
        title: title,
        scene: WeChatScene.SESSION);
    momentShareModel = WeChatShareWebPageModel(url,
        description: description,
        title: title,
        scene: WeChatScene.TIMELINE,
        thumbnail: weChatImage);
  }
}

class _ShareButtonState extends State<ShareButton> {
  TaojuwuShareModel shareModel;

  StreamSubscription subscription;
  @override
  void initState() {
    super.initState();

    OTPService.productShare(params: {"goods_id": widget.id})
        .then((ZYResponse response) async {
      shareModel = await _parse(response.data);
      setState(() {});
    }).catchError((err) {
      print("拉取分享信息出错$err");
    });

    subscription = weChatResponseEventHandler.listen((res) {
      if (res is WeChatShareResponse) {
        if (res.isSuccessful) {
          ToastKit.showSuccessDIYInfo("分享成功!");
        } else {
          ToastKit.showInfo("分享失败!");
        }
      }
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    subscription = null;
    super.dispose();
  }

  Future<TaojuwuShareModel> _parse(Map json) async {
    String image = json["img"];
    String url = json["url"];
    String description = json["others_title"];
    String title = json["title"];
    String suffix = image.substring(image.lastIndexOf("."));
    Uint8List source =
        await NetKit.resolveImageFromUrl(ApiPath.HOST + "/" + image);
    WeChatImage weChatImage = WeChatImage.binary(source, suffix: suffix);
    return TaojuwuShareModel(
        weChatImage: weChatImage,
        url: url,
        sessionShareModel: WeChatShareWebPageModel(url,
            thumbnail: weChatImage,
            description: description,
            title: title,
            scene: WeChatScene.SESSION),
        momentShareModel: WeChatShareWebPageModel(url,
            description: description,
            title: title,
            scene: WeChatScene.TIMELINE,
            thumbnail: weChatImage));
  }

  shareToWxSession() {
    shareToWeChat(shareModel.sessionShareModel).then((value) {
      print(value);
    }).catchError((err) {
      ToastKit.showErrorInfo("分享出错");
    });
  }

  shareToWeChatMoment() {
    shareToWeChat(shareModel.momentShareModel).then((value) {
      print(value);
    }).catchError((err) {
      ToastKit.showErrorInfo("分享出错");
    });
  }

  copyLink() {
    Clipboard.setData(ClipboardData(text: shareModel.url));
    EasyLoading.showSuccess(shareModel.copyTip);
  }

  share() {
    List<XShareModel> list = [
      XShareModel(
          description: "微信好友", icon: "wechat.png", onTap: shareToWxSession),
      XShareModel(
          description: "朋友圈",
          icon: "wechat_moment.png",
          onTap: shareToWeChatMoment),
      XShareModel(description: "复制链接", icon: "copy_link.png", onTap: copyLink),
    ];
    return showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return ClipRRect(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10), topLeft: Radius.circular(10)),
              child: Container(
                height: MediaQuery.of(context).size.height * .36,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).primaryColor,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: UIKit.height(32),
                              horizontal: UIKit.width(20)),
                          child: Text(
                            "分享至",
                            style: TextStyle(
                                fontSize: UIKit.sp(32),
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Divider(
                          height: 8,
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: UIKit.width(32)),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              for (XShareModel e in list)
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: e.onTap,
                                  child: Container(
                                    margin: EdgeInsets.only(right: 32),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(top: 16),
                                          child: Image.asset(
                                            UIKit.getAssetsImagePath(e.icon),
                                            width: 48,
                                            height: 48,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 8),
                                          child: Text(
                                            e.description,
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: const Color(0xFF717171)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                        Container(
                          height: 8,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "取消",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          onTap: Navigator.of(context).pop,
                        )
                      ],
                    ),
                    Positioned(
                      child: IconButton(
                        icon: Icon(ZYIcon.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      top: 5,
                      right: 0,
                    )
                  ],
                ),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: share,
      child: Container(
          child: Image.asset(
        UIKit.getAssetsImagePath("share.png"),
        height: 20,
        width: 20,
      )),
    );
  }
}
