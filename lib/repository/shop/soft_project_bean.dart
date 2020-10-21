/*
 * @Description: 软装方案详情数据模型
 * @Author: iamsmiling
 * @Date: 2020-10-16 15:49:00
 * @LastEditTime: 2020-10-16 16:49:30
 */
import 'package:taojuwu/repository/shop/product_bean.dart';
import 'package:taojuwu/repository/zy_response.dart';
import 'package:taojuwu/utils/common_kit.dart';

class SoftProjectDetailBeanResp extends ZYResponse<SoftProjectDetailBean> {
  SoftProjectDetailBeanResp.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    this.data =
        this.valid ? SoftProjectDetailBean.fromJson(json['data']) : null;
  }
}

class SoftProjectDetailBean {
  int scenesId;
  int scenesType; //1场景 2 软装方案
  String sceneName; // 场景名称
  String picture;
  int shopId;
  double totalPrice;
  String name; //商品名称
  List<SoftProjectGoodsBean> goodsList;

  double get marketPrice {
    double sum = 0.0;
    goodsList?.forEach((element) {
      sum += element?.marketPrice;
    });
    return sum;
  }

  SoftProjectDetailBean.fromJson(Map<String, dynamic> json) {
    scenesId = json['scenes_id'];
    scenesType = json['scenes_type'];
    sceneName = json['scenes_name'];
    picture = json['picture'];
    shopId = json['shop_id'];
    totalPrice = CommonKit.parseDouble(json['total_price']);
    name = json['name'];
    goodsList = CommonKit.parseList(json['goods_list'])
        ?.map((e) => SoftProjectGoodsBean.fromJson(e))
        ?.toList();
  }
}
