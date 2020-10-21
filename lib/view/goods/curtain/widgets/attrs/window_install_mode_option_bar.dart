/*
 * @Description: 安装方式选项
 * @Author: iamsmiling
 * @Date: 2020-10-14 14:38:41
 * @LastEditTime: 2020-10-14 15:21:31
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/repository/shop/sku_attr/window_style_sku_option.dart';
import 'package:taojuwu/viewmodel/goods/binding/curtain/curtain_viewmodel.dart';
import 'package:taojuwu/widgets/zy_outline_button.dart';
import 'package:taojuwu/widgets/zy_raised_button.dart';

class WindowInstallOptionBar extends StatelessWidget {
  const WindowInstallOptionBar({
    Key key,
  }) : super(key: key);

  void _select(BuildContext context, WindowInstallModeOptionBean e,
      StateSetter setState) {
    context.read<CurtainViewModel>().selectInstallMode(e);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Selector(
        builder: (BuildContext context,
            List<WindowInstallModeOptionBean> options, _) {
          return Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  '安装方式',
                  style:
                      TextStyle(color: const Color(0xFF333333), fontSize: 14),
                ),
              ),
              StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Row(
                    children: options
                        .map((e) => Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: e.isChecked
                                  ? ZYRaisedButton(e.name,
                                      () => _select(context, e, setState),
                                      horizontalPadding: 12)
                                  : ZYOutlineButton(e.name,
                                      () => _select(context, e, setState),
                                      horizontalPadding: 12),
                            ))
                        .toList(),
                  );
                },
              )
            ],
          );
        },
        selector: (BuildContext context, CurtainViewModel viewModel) =>
            viewModel.installOptions);
  }
}
