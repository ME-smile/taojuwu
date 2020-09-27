/*
 * @Description: 用户选品
 * @Author: iamsmiling
 * @Date: 2020-09-25 15:39:08
 * @LastEditTime: 2020-09-25 16:47:52
 */
class SelectProductEvent {
  final int orderGoodsId;
  final int status; //选品状态  0 待选品  1--选品完成
  const SelectProductEvent(this.orderGoodsId, {this.status = 0});
}
