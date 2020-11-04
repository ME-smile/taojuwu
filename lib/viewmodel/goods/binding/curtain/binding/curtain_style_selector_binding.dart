/*
 * @Description: 处理窗帘样式 安装选项 打开方式相关的逻辑
 * @Author: iamsmiling
 * @Date: 2020-09-29 16:08:31
 * @LastEditTime: 2020-11-02 09:27:58
 */
import 'package:taojuwu/repository/shop/sku_attr/window_style_sku_option.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/viewmodel/goods/binding/base/curtain_goods_binding.dart';

mixin CurtainStyleSelectorBinding on CurtainGoodsBinding {
  //窗型列表
  List<WindowAttrOptionBean> typeOptions = [
    WindowAttrOptionBean(1, '单窗', 'single_window_pattern.png', isChecked: true),
    WindowAttrOptionBean(2, 'L型窗', 'L_window_pattern.png'),
    WindowAttrOptionBean(3, 'U型窗', 'U_window_pattern.png')
  ];

  // 有无飘窗
  List<WindowAttrOptionBean> bayOptions = [
    WindowAttrOptionBean(1, '非飘窗', 'not_bay_window.png', isChecked: true),
    WindowAttrOptionBean(2, '飘窗', 'bay_window.png'),
  ];

  // 是否有盒
  List<WindowAttrOptionBean> boxOptions = [
    WindowAttrOptionBean(1, '无盒', 'window_no_can.png', isChecked: true),
    WindowAttrOptionBean(2, '有盒', 'not_bay_window.png')
  ];
  //当前的窗帘样式 单窗 L窗 U窗,默认单窗
  String get windowType => getSelectedOption(typeOptions)?.name ?? '单窗';

  //当前的窗帘样式 有无飘窗
  String get windowBay => getSelectedOption(bayOptions)?.name ?? '非飘窗';

  //有无窗帘盒
  String get windowBox => getSelectedOption(boxOptions)?.name ?? '无盒';

  //窗帘样式
  String get windowStyleStr => '$windowType/$windowBay/$windowBox';

  //顶部展示的主图
  String get mainImg {
    return curInstallMode == null
        ? 'curtain/size_0100-1-1-SPW-H.png'
        : curInstallMode.img;
  }

  //获取当前选中的样式选项--->WindowStyleProductSkuBean对象
  WindowStyleProductSkuBean get curStyleProductSkuBean {
    List<WindowStyleProductSkuBean> list = styleSkuOption?.options;
    if (!CommonKit.isNullOrEmpty(list)) {
      WindowStyleProductSkuBean bean = list.firstWhere(
          (element) => element.name == windowStyleStr,
          orElse: () => getFirst(list));
      return bean;
    }
    return null;
  }

  // 当前的安装方式
  WindowInstallModeOptionBean get curInstallMode {
    List<WindowInstallModeOptionBean> array =
        curStyleProductSkuBean?.installModeOptionBeans;
    if (!CommonKit.isNullOrEmpty(array)) {
      WindowInstallModeOptionBean bean = array.firstWhere(
          (element) => element.isChecked,
          orElse: () => getFirst(array));
      return bean;
    }
    return null;
  }

  //获取选中的选项
  WindowAttrOptionBean getSelectedOption(List<WindowAttrOptionBean> options) {
    return options.firstWhere((element) => element.isChecked,
        orElse: () => null);
  }

  // 获取当前应该显示的安装方式
  List<WindowInstallModeOptionBean> get installOptions =>
      curStyleProductSkuBean?.installModeOptionBeans ?? [];
  // 获取当前应该显示的打开方式
  List<WindowOpenModeOptionBean> get openOptions =>
      curStyleProductSkuBean?.openModeOptionBeans ?? [];

  //选择安装方式
  void selectInstallMode(WindowInstallModeOptionBean bean) {
    installOptions.forEach((element) {
      element.isChecked = element == bean;
    });
    notifyListeners();
  }

  //选择打开方式
  void selectOpenMode(WindowOpenModeOptionBean bean) {
    openOptions.forEach((element) {
      element.isChecked = element == bean;
    });
  }

  // 获取选中的安装选项
  WindowInstallModeOptionBean get selectedInstallModeOption {
    return installOptions?.firstWhere((element) => element.isChecked,
        orElse: () => getFirst(installOptions));
  }

  // 获取选中的打开方式
  WindowOpenModeOptionBean get selectedOpenModeOption {
    return openOptions?.firstWhere((element) => element.isChecked,
        orElse: () => getFirst(openOptions));
  }

  getFirst(List list) {
    return CommonKit.isNullOrEmpty(list) ? null : list?.first;
  }

  //获取当前选中的打开方式的子选项
  List<WindowOpenModeSubOption> get subOpenModeOptions =>
      selectedOpenModeOption?.subOptions ?? [];

  //选中子选项
  void selectSubOpenMode(
      WindowOpenModeSubOption option, WindowOpenModeSubOptionBean optionBean) {
    option.options.forEach((element) {
      element.isChecked = element == optionBean;
    });
  }

  int get styleOptionId => curStyleProductSkuBean?.id;
}
