/*
 * @Description: 安装方式选项
 * @Author: iamsmiling
 * @Date: 2020-10-14 14:38:41
 * @LastEditTime: 2020-10-31 17:37:09
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/base_curtain_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/style_selector/curtain_style_selector.dart';
import 'package:taojuwu/repository/shop/sku_attr/window_style_sku_option.dart';
import 'package:taojuwu/widgets/zy_outline_button.dart';
import 'package:taojuwu/widgets/zy_raised_button.dart';

class WindowInstallOptionBar extends StatefulWidget {
  final BaseCurtainProductDetailBean bean;
  const WindowInstallOptionBar(
    this.bean, {
    Key key,
  }) : super(key: key);

  @override
  _WindowInstallOptionBarState createState() => _WindowInstallOptionBarState();
}

class _WindowInstallOptionBarState extends State<WindowInstallOptionBar> {
  CurtainStyleSelector get styleSelector => widget?.bean?.styleSelector;
  void _select(
    BuildContext context,
    WindowInstallModeOptionBean e,
  ) {
    setState(() {
      styleSelector.selectInstallMode(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '安装方式',
            style: TextStyle(color: const Color(0xFF333333), fontSize: 14),
          ),
        ),
        Row(
          children: widget.bean?.styleSelector?.installOptions
                  ?.map((e) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: e.isChecked
                            ? ZYRaisedButton(e.name, () => _select(context, e),
                                horizontalPadding: 12)
                            : ZYOutlineButton(e.name, () => _select(context, e),
                                horizontalPadding: 12),
                      ))
                  ?.toList() ??
              [],
        )
      ],
    );
    // return Selector(
    //     builder: (BuildContext context,
    //         List<WindowInstallModeOptionBean> options, _) {
    //       return Row(
    //         children: [
    //           SizedBox(
    //             width: 80,
    //             child: Text(
    //               '安装方式',
    //               style:
    //                   TextStyle(color: const Color(0xFF333333), fontSize: 14),
    //             ),
    //           ),
    //           StatefulBuilder(
    //             builder: (BuildContext context, StateSetter setState) {
    //               return Row(
    //                 children: options
    //                     .map((e) => Container(
    //                           margin: EdgeInsets.symmetric(horizontal: 10),
    //                           child: e.isChecked
    //                               ? ZYRaisedButton(e.name,
    //                                   () => _select(context, e, setState),
    //                                   horizontalPadding: 12)
    //                               : ZYOutlineButton(e.name,
    //                                   () => _select(context, e, setState),
    //                                   horizontalPadding: 12),
    //                         ))
    //                     .toList(),
    //               );
    //             },
    //           )
    //         ],
    //       );
    //     },
    //     selector: (BuildContext context, CurtainViewModel viewModel) =>
    //         viewModel.installOptions);
  }
}
