/*
 * @Description: 用户选品
 * @Author: iamsmiling
 * @Date: 2020-09-25 15:39:08
 * @LastEditTime: 2020-11-18 13:13:57
 */
import 'package:taojuwu/repository/shop/product_detail/abstract/abstract_base_product_detail_bean.dart';

class SelectProductEvent {
  final int orderGoodsId;
  final int status; //选品状态  0 待选品  1--选品完成
  final ProductType productType;
  const SelectProductEvent(this.orderGoodsId,
      {this.status = 0,
      this.productType = ProductType.FabricCurtainProductType});
}
