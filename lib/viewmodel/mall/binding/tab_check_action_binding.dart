/*
 * @Description: 处理tab切换相关的逻辑
 * @Author: iamsmiling
 * @Date: 2020-10-10 09:06:10
 * @LastEditTime: 2020-10-10 10:33:09
 */
import 'package:taojuwu/application.dart';
import 'package:taojuwu/repository/shop/tag_model.dart';
import 'package:taojuwu/viewmodel/mall/binding/base_mall_action_binding.dart';
import 'package:taojuwu/viewmodel/mall/event/refresh_list_event.dart';

mixin TabCheckActionBinding on BaseMallActionBinding {
  TagFilterWrapper tagWrapper; //tag列表

  // bool _hasInit = false; //标示位，保证只被初始一次
  @override
  void addListener(listener) {
    tabController?.addListener(_checkTab);
    super.addListener(listener);
    // if (!_hasInit) {
    //   _init();
    //   super.addListener(listener);
    // }
  }

  @override
  void removeListener(listener) {
    tabController?.removeListener(_checkTab);
    super.removeListener(listener);
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  //切换tab刷新列表，重新请求tag
  void _checkTab() {
    Application.eventBus.fire(RefreshListEvent({'page_index': 1},
        isRefresh: true, isPullDown: false));
    requestFilterTag();
  }
}
