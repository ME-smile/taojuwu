/*
 * @Description: 确认选品地步操作栏
 * @Author: iamsmiling
 * @Date: 2020-09-27 15:06:52
 * @LastEditTime: 2020-09-27 15:09:52
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/viewmodel/goods/binding/curtain/curtain_viewmodel.dart';
import 'package:taojuwu/widgets/zy_raised_button.dart';

class SelectProductActionBar extends StatelessWidget {
  const SelectProductActionBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Consumer<CurtainViewModel>(
      builder: (BuildContext context, CurtainViewModel viewModel, _) {
        return Container(
            color: themeData.primaryColor,
            padding: EdgeInsets.symmetric(
              horizontal: UIKit.width(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text.rich(TextSpan(text: '预计:\n', children: [
                  TextSpan(text: '¥${viewModel?.totalPrice ?? 0.00}'),
                ])),
                ZYRaisedButton(
                  '确认选品',
                  () {
                    // viewModel?.selectProduct(context);
                  },
                  horizontalPadding: 32,
                  verticalPadding: 8,
                  fontsize: 16,
                )
              ],
            ));
      },
    );
  }
}
