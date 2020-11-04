/*
 * @Description: 窗帘  单窗有盒无盒  飘窗 非飘窗
 * @Author: iamsmiling
 * @Date: 2020-10-20 11:26:33
 * @LastEditTime: 2020-10-20 11:28:09
 */
import 'window_style_sku_option.dart';

class WindowStyle {
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

  //获取选中的选项
  WindowAttrOptionBean getSelectedOption(List<WindowAttrOptionBean> options) {
    return options.firstWhere((element) => element.isChecked,
        orElse: () => null);
  }

  //当前的窗帘样式 单窗 L窗 U窗,默认单窗
  String get windowType => getSelectedOption(typeOptions)?.name ?? '单窗';

  //当前的窗帘样式 有无飘窗
  String get windowBay => getSelectedOption(bayOptions)?.name ?? '非飘窗';

  //有无窗帘盒
  String get windowBox => getSelectedOption(boxOptions)?.name ?? '无盒';

  //窗帘样式
  String get windowStyleStr => '$windowType/$windowBay/$windowBox';
}
