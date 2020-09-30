/*
 * @Description: 处理窗帘样式 安装选项 打开方式相关的逻辑
 * @Author: iamsmiling
 * @Date: 2020-09-29 16:08:31
 * @LastEditTime: 2020-09-30 14:41:58
 */
import 'package:taojuwu/repository/shop/sku_attr/curtain_sku_attr.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/viewmodel/goods/binding/base/curtain_goods_binding.dart';

mixin CurtainStyleSelectorBinding on CurtainGoodsBinding {
  //当前的窗帘样式 单窗 L窗 U窗
  StyleOptionAttrBean get curCurtainStyleBean =>
      getSelectedStyleOptionBeanById(1);
  // 获取当前样式的名称 单窗 L窗 U窗
  String get curCurtainStyleBeanName => curCurtainStyleBean?.text ?? '';

  //当前的窗帘样式 有无飘窗
  StyleOptionAttrBean get curCurtainPatternBean =>
      getSelectedStyleOptionBeanById(2);

  String get curCurtainPatternBeanName => curCurtainPatternBean?.text ?? '';

  //当前的窗帘样式 是否带盒
  StyleOptionAttrBean get curCurtainModeBean =>
      getSelectedStyleOptionBeanById(3);
  String get curCurtainModeBeanName => curCurtainModeBean?.text ?? '';

  //拼接字符串 -->单窗/飘窗/有盒 格式
  String get stylePatternMode =>
      '$curCurtainStyleBeanName/$curCurtainPatternBean/$curCurtainModeBeanName';
  /*
   * @Author: iamsmiling
   * @description: 通过id获取到样式 窗型 盒的有无 属性 1 样式 2 窗型 3 盒
   * @param : id
   * @return CurtainStyleOptionAttr
   * @Date: 2020-09-30 14:04:06
   */
  CurtainStyleOptionAttr getCurtainStyleOptionAttrById(int id) {
    List<CurtainStyleOptionAttr> list = curtainSkuAttr?.styleOptionAttrs;
    if (CommonKit.isNullOrEmpty(list)) return null;
    return list.firstWhere((el) => el.id == id);
  }
/*  
 * @Author: iamsmiling
 * @description: 传入一个属性获取到当前的选中的样式
 * @param : 
 * @return {type} 
 * @Date: 2020-09-30 14:19:04
 */

  StyleOptionAttrBean getSelectedStyleOptionBean(CurtainStyleOptionAttr attr) {
    if (CommonKit.isNullOrEmpty(attr?.options) ?? true) return null;
    return attr.options.firstWhere((element) => element.isChecked);
  }

  StyleOptionAttrBean getSelectedStyleOptionBeanById(int id) {
    return getSelectedStyleOptionBean(getCurtainStyleOptionAttrById(id));
  }

  // 当前的安装选项
  CurtainInstallOptionAttr get curInstallModeOption =>
      getCurtainInstallOptionAttrByName(stylePatternMode);

  //通过name匹配安装选项
  CurtainInstallOptionAttr getCurtainInstallOptionAttrByName(name) {
    List list = curtainSkuAttr.installOptionAttrs;
    if (CommonKit.isNullOrEmpty(list)) return null;
    return list.firstWhere((element) => element.name == name);
  }

  // 获取当前选中的安装选项
  InstallModeOptionBean get curInstallModeOptionBean {
    List<CurtainInstallOptionAttr> list = curtainSkuAttr?.installOptionAttrs;
    if (CommonKit.isNullOrEmpty(list)) return null;
    int index = list.indexOf(curInstallModeOption);
    if (index == -1) return null;
    return curInstallModeOption.options
        .firstWhere((element) => element.isChecked);
  }

  String get mainImg => curInstallModeOptionBean == null
      ? 'curtain/size_0100-1-1-SPW-H.png'
      : curInstallModeOptionBean.picture;
}
