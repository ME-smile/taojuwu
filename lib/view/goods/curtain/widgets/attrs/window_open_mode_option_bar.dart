/*
 * @Description: 打开方式选项
 * @Author: iamsmiling
 * @Date: 2020-10-14 14:38:41
 * @LastEditTime: 2020-10-31 17:37:32
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/base_curtain_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/style_selector/curtain_style_selector.dart';
import 'package:taojuwu/repository/shop/sku_attr/window_style_sku_option.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/widgets/zy_outline_button.dart';
import 'package:taojuwu/widgets/zy_raised_button.dart';

class WindowOpenOptionBar extends StatefulWidget {
  final BaseCurtainProductDetailBean bean;
  const WindowOpenOptionBar(
    this.bean, {
    Key key,
  }) : super(key: key);

  @override
  _WindowOpenOptionBarState createState() => _WindowOpenOptionBarState();
}

class _WindowOpenOptionBarState extends State<WindowOpenOptionBar> {
  CurtainStyleSelector get styleSelector => widget.bean?.styleSelector;
  void _selectOpenMode(BuildContext context, WindowOpenModeOptionBean e) {
    setState(() {
      styleSelector?.selectOpenMode(e);
    });
  }

  void _selectSubOpenMode(BuildContext context, WindowOpenModeSubOption option,
      WindowOpenModeSubOptionBean optionBean) {
    setState(() {
      styleSelector?.selectSubOpenMode(option, optionBean);
    });
  }

  @override
  Widget build(BuildContext context) {
    //StatefulBuilder
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 80,
              child: Text(
                '打开方式',
                style: TextStyle(color: const Color(0xFF333333), fontSize: 14),
              ),
            ),
            Row(
              children: styleSelector.openOptions
                  .map((e) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: e.isChecked
                            ? ZYRaisedButton(
                                e.name, () => _selectOpenMode(context, e),
                                horizontalPadding: 12)
                            : ZYOutlineButton(
                                e.name, () => _selectOpenMode(context, e),
                                horizontalPadding: 12),
                      ))
                  .toList(),
            ),
            Visibility(
                child: Column(
                  children: styleSelector?.subOpenModes
                      ?.map((e) => Container(
                            child: Row(
                              children: [
                                Text(
                                  e?.title ?? '',
                                  style: TextStyle(
                                      color: const Color(0xFF333333),
                                      fontSize: 14),
                                ),
                                Row(
                                  children: e.options
                                      .map((item) => Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: item.isChecked
                                              ? ZYRaisedButton(
                                                  item?.name,
                                                  () => _selectSubOpenMode(
                                                        context,
                                                        e,
                                                        item,
                                                      ),
                                                  horizontalPadding: 12)
                                              : ZYOutlineButton(
                                                  item?.name,
                                                  () => _selectSubOpenMode(
                                                      context, e, item),
                                                  horizontalPadding: 12)))
                                      ?.toList(),
                                )
                              ],
                            ),
                          ))
                      ?.toList(),
                ),
                visible: !CommonKit.isNullOrEmpty(styleSelector?.subOpenModes))
          ],
        )
      ],
    );
  }
}
