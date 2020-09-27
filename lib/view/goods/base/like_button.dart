/*
 * @Description: 收藏按钮的封装
 * @Author: iamsmiling
 * @Date: 2020-09-25 12:47:45
 * @LastEditTime: 2020-09-27 14:04:07
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:taojuwu/application.dart';
import 'package:taojuwu/event_bus/events/select_client_event.dart';
import 'package:taojuwu/repository/zy_response.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/toast_kit.dart';
import 'package:taojuwu/utils/ui_kit.dart';

class LikeButton extends StatefulWidget {
  final int goodsId; //商品的id
  final bool hasLiked; //初始状态是否为收藏
  LikeButton({Key key, this.hasLiked = false, this.goodsId}) : super(key: key);

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  StreamSubscription _streamSubscription;

  int _clientId;

  int get id => widget.goodsId;
  bool _hasLiked = false;

  @override
  void initState() {
    super.initState();
    _hasLiked = widget.hasLiked ?? false; // 初始化收藏状态
    _streamSubscription =
        Application.eventBus.on<SelectClientEvent>().listen((event) {
      _clientId = event?.mTargetClient?.clientId;
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  collect() {
    if (_clientId == null) {
      ToastKit.showInfo('请选择客户');
      return;
    }
    Map<String, dynamic> args = {
      'fav_id': id,
      'client_uid': _clientId,
    };

    if (_hasLiked == false) {
      OTPService.collect(params: args)
          .then((ZYResponse response) {
            if (response?.valid == true) {
              _hasLiked = true;
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
              _hasLiked = false;
            }
          })
          .catchError((err) => err)
          .whenComplete(() {
            setState(() {});
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: collect,
      child: Container(
          child: Image.asset(
        UIKit.getAssetsImagePath(
          _hasLiked ? 'heart_fill.png' : 'heart_blank.png',
        ),
        width: 22,
        height: 22,
      )),
    );
  }
}
