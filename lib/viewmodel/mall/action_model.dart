/*
 * @Description: 处理列表刷新的逻辑
 * @Author: iamsmiling
 * @Date: 2020-10-10 09:07:15
 * @LastEditTime: 2020-10-10 11:37:23
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:taojuwu/application.dart';
import 'package:taojuwu/repository/shop/curtain_product_list_model.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/viewmodel/mall/binding/base_mall_action_binding.dart';
import 'package:taojuwu/viewmodel/mall/binding/pull_action_binding.dart';
import 'package:taojuwu/viewmodel/mall/binding/sort_action_binding.dart';
import 'package:taojuwu/viewmodel/mall/binding/tab_check_action_binding.dart';
import 'package:taojuwu/viewmodel/mall/event/refresh_list_event.dart';

class ActionModel extends BaseMallActionBinding
    with SortActionBinding, TabCheckActionBinding, PullActionBinding {
  StreamSubscription _streamSubscription;
  ActionModel(TabController controller) {
    tabController = controller;
    _streamSubscription =
        Application.eventBus.on<RefreshListEvent>().listen((event) {
      requestData(isRefresh: event.isRefresh);
    });
    //首次进入页面加载数据
    requestData();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Future requestData({bool isRefresh = false, bool isPullDown = true}) {
    return OTPService.productGoodsList(context, params: params)
        .then((CurtainProductListResp response) {
      List<GoodsItemBean> list = response?.data?.goodsList?.data ?? [];
      totalCount = response?.data?.totalCount;
      // ignore: unnecessary_statements
      isRefresh ? goodsList?.clear() : '';
      goodsList.addAll(list);
      isPullDown
          ? refreshController?.refreshCompleted()
          : refreshController?.loadComplete();
    }).catchError((err) {
      isRefresh
          ? refreshController?.refreshFailed()
          : refreshController?.loadFailed();
    }).whenComplete(() {
      notifyListeners();
    });
  } // 请求商品列表数据的接口

  @override
  Future requestFilterTag() {
    return OTPService.tagList(context, params: params);
  } // 请求
}
