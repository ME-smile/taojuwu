/*
 * @Description: 处理下拉刷新，下拉加载更多的逻辑
 * @Author: iamsmiling
 * @Date: 2020-10-10 09:10:04
 * @LastEditTime: 2020-10-10 11:46:08
 */
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:taojuwu/application.dart';
import 'package:taojuwu/viewmodel/mall/binding/base_mall_action_binding.dart';
import 'package:taojuwu/viewmodel/mall/event/refresh_list_event.dart';

mixin PullActionBinding on BaseMallActionBinding {
  RefreshController refreshController = RefreshController(
      initialRefresh: false, initialLoadStatus: LoadStatus.idle);

  void onRefresh() {
    Application.eventBus
        .fire(RefreshListEvent({'page_index': 1}, isRefresh: true));
  }

  int get totalPage {
    if (totalCount == 0) {
      return 0;
    }
    int mod = totalCount % pageSize;
    int div = totalCount ~/ pageSize;
    return mod == 0 ? div : div + 1;
  }

  bool get hasMoreData => currentPage <= totalPage;

  void onLoad() {
    currentPage++;
  }

  @override
  void dispose() {
    refreshController?.dispose();
    super.dispose();
  }
}
