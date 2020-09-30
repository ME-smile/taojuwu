/*
 * @Description: 窗帘   样式 窗型 盒的类操作
 * @Author: iamsmiling
 * @Date: 2020-09-29 13:56:00
 * @LastEditTime: 2020-09-30 14:11:42
 */
import 'package:taojuwu/utils/common_kit.dart';

class CurtainSkuAttr {
  List<CurtainInstallOptionAttr> installOptionAttrs;
  List<CurtainStyleOptionAttr> styleOptionAttrs;
  CurtainSkuAttr.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> map = json['data'];
    installOptionAttrs = CommonKit.parseList(map['install_options'])
        .map((e) => CurtainInstallOptionAttr.fromJson(e))
        .toList();
    styleOptionAttrs = CommonKit.parseList(map['style_options'])
        .map((e) => CurtainStyleOptionAttr.fromJson(e))
        .toList();
  }
}

class CurtainInstallOptionAttr {
  String name;
  int id;
  List<InstallModeOptionBean> options;

  CurtainInstallOptionAttr.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    options = CommonKit.parseList(json['install_mode'])
        .map((e) => InstallModeOptionBean.fromJson(e))
        .toList();
  }
}

class InstallModeOptionBean {
  String name;
  String picture;
  bool isChecked;
  InstallModeOptionBean.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    picture = json['picture'];
    isChecked = json['is_checked'];
  }
}

class CurtainStyleOptionAttr {
  String title;
  int id;
  List<StyleOptionAttrBean> options;

  CurtainStyleOptionAttr.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    id = json['id'];
    options = CommonKit.parseList(json['options'])
        .map((e) => StyleOptionAttrBean.fromJson(e))
        .toList();
  }
}

class StyleOptionAttrBean {
  String text;
  String img;
  bool isChecked;
  OpenModeOptionAttr options;
  StyleOptionAttrBean.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    img = json['img'];
    isChecked = json['is_checked'];
    options = OpenModeOptionAttr.fromJson(json['open_options']);
  }
}

class OpenModeOptionAttr {
  String text;
  List<OpenModeOptionBean> options;

  OpenModeOptionAttr.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    options = CommonKit.parseList(json['list'])
        .map((e) => OpenModeOptionBean.fromJson(e))
        .toList();
  }
}

class OpenModeOptionBean {
  String name;
  bool isChecked;

  OpenModeOptionBean({this.name, this.isChecked});

  OpenModeOptionBean.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    isChecked = json['is_checked'];
  }
}
