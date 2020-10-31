/*
 * @Description: 样式选择holder
 * @Author: iamsmiling
 * @Date: 2020-10-30 13:55:28
 * @LastEditTime: 2020-10-31 07:18:11
 */
import 'package:taojuwu/repository/shop/product/curtain/style_selector/curtain_style_selector.dart';

class StyleSelectorHolder {
  static CurtainStyleSelector _styleSelector = CurtainStyleSelector();

  CurtainStyleSelector get styleSelector => _styleSelector;

  set styleSelector(CurtainStyleSelector style) {
    _styleSelector = style;
    print(style);
  }

  static CurtainStyleSelector copy() {
    return _styleSelector.copy();
  }
}
