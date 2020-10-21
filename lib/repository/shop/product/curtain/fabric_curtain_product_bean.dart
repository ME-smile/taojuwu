/*
 * @Description: 布艺帘商品
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:12:26
 * @LastEditTime: 2020-10-21 15:46:16
 */

import 'base_curtain_product_bean.dart';
import 'style_selector/curtain_style_selector.dart';

class FabricCurtainProductBean extends BaseCurtainProductBean {
  CurtainStyleSelector styleSelector; // 样式选择  只有布艺帘才需要选择 这些属性

  FabricCurtainProductBean.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    styleSelector = CurtainStyleSelector();
  }
}
