/*
 * @Description: 收藏安努
 * @Author: iamsmiling
 * @Date: 2020-10-28 15:04:00
 * @LastEditTime: 2020-11-06 10:06:26
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
  final bool hasLiked;
  final int goodsId;
  const LikeButton({Key key, this.hasLiked, this.goodsId}) : super(key: key);

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool hasLiked;
  int get goodsId => widget.goodsId;

  int clientId;
  //监听选择客户的事件
  StreamSubscription _subscription;

  @override
  void initState() {
    hasLiked = widget.hasLiked;
    _subscription =
        Application.eventBus.on<SelectClientEvent>().listen((event) {
      clientId = event.mTargetClient.clientId;
      _fetchData();
    });
    super.initState();
  }

  void _fetchData() {
    OTPService.hasCollect(params: {}).then((ZYResponse response) {
      if (response?.valid == true) {
        hasLiked = response?.data == 1;
      }
    }).whenComplete(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  //收藏和取消收藏
  Future _like() {
    return OTPService.collect(params: {
      'fav_id': goodsId,
      'client_uid': clientId,
    })
        .then((ZYResponse response) {
          if (response?.valid == true) {
            hasLiked = true;
          }
        })
        .catchError((err) => err)
        .whenComplete(() {
          setState(() {});
        });
  }

  //取消收藏
  Future _dislike() {
    return OTPService.cancelCollect(params: {
      'fav_id': goodsId,
      'client_uid': clientId,
    })
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

  Future like() {
    if (clientId == null) {
      ToastKit.showInfo('请先选择客户哦');
      return Future.value(false);
    }
    return hasLiked ? _dislike() : _like();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: like,
      child: Container(
          child: Image.asset(
        UIKit.getAssetsImagePath(
          hasLiked ? 'heart_fill.png' : 'heart_blank.png',
        ),
        height: 20,
        width: 20,
      )),
    );
  }
}
