/*
 * @Description: 相关场景数据模型
 * @Author: iamsmiling
 * @Date: 2020-10-16 10:32:19
 * @LastEditTime: 2020-10-23 13:14:28
 */
import 'package:taojuwu/repository/shop/product_detail/design/scene_design_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_bean.dart';
import 'package:taojuwu/repository/zy_response.dart';
import 'package:taojuwu/utils/common_kit.dart';

class SceneDetailModelResp extends ZYResponse<SceneProjectDetailWrapper> {
  SceneDetailModelResp.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    this.data =
        this.valid ? SceneProjectDetailWrapper.fromJson(json['data']) : null;
  }
}

class SceneProjectDetailWrapper {
  SceneDesignProductDetailBean currentBean;
  List<SceneDesignProductDetailBean> list;
  SceneProjectBean curSoftProject;
  List<SceneProjectBean> projectList;

  SceneProjectDetailWrapper.fromJson(Map<String, dynamic> json) {
    currentBean = SceneDesignProductDetailBean.fromJson(json['scenes_detail']);
    list = CommonKit.parseList(json['related_scenes'])
        .map((e) => SceneDesignProductDetailBean.fromJson(e))
        ?.toList();
    curSoftProject = SceneProjectBean.fromJson(json['scenes_detail']);
    projectList = CommonKit.parseList(json['related_scenes'])
        .map((e) => SceneProjectBean.fromJson(e))
        ?.toList();
  }
}
