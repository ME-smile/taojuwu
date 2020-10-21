/*
 * @Description: 所有操作类的基类
 * @Author: iamsmiling
 * @Date: 2020-10-09 18:04:43
 * @LastEditTime: 2020-10-10 11:44:17
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/curtain_product_list_model.dart';

abstract class BaseMallActionBinding with ChangeNotifier {
  BuildContext context;

  List<GoodsItemBean> goodsList = [];

  int totalCount = 0; // 商品总数，默认为0

  int pageSize = 20; // 每一页请求的个数

  int currentPage = 1; //当前页

  TabController
      tabController; //持有tabControler的句柄，方便tab_check_action_binding进行操作

  Future requestData({bool isRefresh = false}); // 请求商品列表数据的接口

  Future requestFilterTag(); // 请求筛选tag

  void refreshData(List<GoodsItemBean> list) {
    goodsList.clear();
    goodsList.addAll(list);
  }

  Map<String, dynamic> get params => {
        'order': 'sales',
        'sort': 'desc',
        'page_size': pageSize,
        'page_index': currentPage,
      };
}
