/*
 * @Description: 窗帘  窗型 飘窗 盒 的选择
 * @Author: iamsmiling
 * @Date: 2020-10-14 10:03:41
 * @LastEditTime: 2020-11-02 09:25:28
 */
import 'package:taojuwu/utils/common_kit.dart';

class WindowAttrOptionBean {
  String name;
  String img;
  bool isChecked;
  int id;
  WindowAttrOptionBean(this.id, this.name, this.img, {this.isChecked = false});

  WindowAttrOptionBean.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    img = json['img'];
    isChecked = json['is_checked'];
  }
  Map<String, dynamic> toJson() =>
      {'name': name, 'img': img, 'is_checked': isChecked};
}

class WindowStyleSkuOption {
  List<WindowStyleProductSkuBean> options;
  WindowStyleSkuOption.fromJson(Map<String, dynamic> json) {
    options = CommonKit.parseList(json['data'])
        ?.map((e) => WindowStyleProductSkuBean.fromJson(e))
        ?.toList();
  }
}

class WindowStyleProductSkuBean {
  String name;
  int id;
  List<WindowInstallModeOptionBean> installModeOptionBeans;
  List<WindowOpenModeOptionBean> openModeOptionBeans;
  WindowStyleProductSkuBean.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    installModeOptionBeans = CommonKit.parseList(json['install_modes'])
        ?.map((e) => WindowInstallModeOptionBean.fromJson(e))
        ?.toList();
    openModeOptionBeans = CommonKit.parseList(json['open_modes'])
        ?.map((e) => WindowOpenModeOptionBean.fromJson(e))
        ?.toList();
  }

  WindowStyleProductSkuBean(
      {this.id,
      this.name,
      this.installModeOptionBeans,
      this.openModeOptionBeans});

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'install_modes':
            installModeOptionBeans?.map((e) => e?.toJson())?.toList(),
        'open_modes': openModeOptionBeans?.map((e) => e?.toJson())?.toList()
      };
}

class WindowInstallModeOptionBean {
  String name;
  String img;
  bool isChecked;

  WindowInstallModeOptionBean.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    img = json['img'];
    isChecked = json['is_checked'];
  }

  Map<String, dynamic> toJson() =>
      {'name': name, 'is_checked': isChecked, 'img': img};
}

class WindowOpenModeOptionBean {
  String name;
  bool isChecked;
  int index;
  List<WindowOpenModeSubOption> subOptions = [];
  WindowOpenModeOptionBean.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    isChecked = json['is_checked'];
    index = json['index'];
    subOptions = CommonKit.parseList(json['sub_options'])
        ?.map((e) => WindowOpenModeSubOption.fromJson(e))
        ?.toList();
  }
  Map<String, dynamic> toJson() => {
        'name': name,
        'is_checked': isChecked,
        'index': index,
        'sub_options': subOptions?.map((e) => e?.toJson())?.toList()
      };
}

class WindowOpenModeSubOption {
  String title;
  List<WindowOpenModeSubOptionBean> options;

  WindowOpenModeSubOption.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    options = CommonKit.parseList(json['options'])
        ?.map((e) => WindowOpenModeSubOptionBean.fromJson(e))
        ?.toList();
  }

  Map<String, dynamic> toJson() =>
      {'title': title, 'options': options?.map((e) => e?.toJson())?.toList()};
}

class WindowOpenModeSubOptionBean {
  String name;
  bool isChecked;

  WindowOpenModeSubOptionBean.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    isChecked = json['is_checked'];
  }

  Map<String, dynamic> toJson() => {'name': name, 'is_checked': isChecked};
}
