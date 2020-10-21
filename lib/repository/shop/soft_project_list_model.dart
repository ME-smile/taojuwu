/*
 * @Description: 软装方案列表
 * @Author: iamsmiling
 * @Date: 2020-10-16 14:29:28
 * @LastEditTime: 2020-10-16 15:31:14
 */
import 'package:taojuwu/repository/shop/product_bean.dart';
import 'package:taojuwu/repository/zy_response.dart';
import 'package:taojuwu/utils/common_kit.dart';

class SoftProjectListResp extends ZYResponse<SoftProjectListWrapper> {
  SoftProjectListResp.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    this.data = this.valid ? SoftProjectListWrapper.fromJson(json) : null;
  }
}

class SoftProjectListWrapper {
  List<SoftProjectBean> list;
  SoftProjectListWrapper.fromJson(Map<String, dynamic> json) {
    print(json);
    list = CommonKit.parseList(json['data'])
        ?.map((e) => SoftProjectBean.fromJson(e))
        ?.toList();
  }
}
