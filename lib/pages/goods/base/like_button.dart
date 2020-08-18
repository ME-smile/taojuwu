import 'package:flutter/material.dart';
import 'package:taojuwu/models/zy_response.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/utils/ui_kit.dart';

class LikeButton extends StatefulWidget {
  final int goodsId;
  final int clientId;
  final bool hasLiked;
  final Function callback;
  LikeButton(
      {Key key,
      this.hasLiked = false,
      this.callback,
      this.clientId,
      this.goodsId})
      : super(key: key);

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  Function get callback => widget.callback;
  int get id => widget.goodsId;
  int get clientId => widget.clientId;
  bool hasLiked = false;
  collect() {
    if (clientId == null) {
      CommonKit.showInfo('请选择客户');
      return;
    }
    Map<String, dynamic> args = {
      'fav_id': id,
      'client_uid': clientId,
    };
    print(hasLiked);
    if (hasLiked == false) {
      OTPService.collect(params: args)
          .then((ZYResponse response) {
            if (response?.valid == true) {
              hasLiked = true;
            }
          })
          .catchError((err) => err)
          .whenComplete(() {
            setState(() {});
          });
    } else {
      OTPService.cancelCollect(params: args)
          .then((ZYResponse response) {
            if (response?.valid == true) {
              hasLiked = false;
            }
          })
          .catchError((err) => err)
          .whenComplete(() {
            setState(() {});
          });
    }
  }

  @override
  void initState() {
    hasLiked = widget.hasLiked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(hasLiked);
    return InkWell(
      onTap: collect,
      child: Container(
          child: Image.asset(
        UIKit.getAssetsImagePath(
          hasLiked ? 'heart_fill.png' : 'heart_blank.png',
        ),
        width: 22,
        height: 22,
      )),
    );
  }
}
