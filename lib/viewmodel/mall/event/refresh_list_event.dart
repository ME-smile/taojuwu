/*
 * @Description: 刷新列表事件  接收一个map参数
 * @Author: iamsmiling
 * @Date: 2020-10-10 09:28:28
 * @LastEditTime: 2020-10-10 10:26:16
 */
class RefreshListEvent {
  final bool isPullDown; // 是否为下拉行为,默认为true
  final bool isRefresh; // 是否进行刷新
  final Map<String, dynamic> args; //请求参数

  RefreshListEvent(this.args, {this.isRefresh = false, this.isPullDown = true});
}
