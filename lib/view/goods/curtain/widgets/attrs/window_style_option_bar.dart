/*
 * @Description: 属性选泽
 * @Author: iamsmiling
 * @Date: 2020-09-25 12:47:45
 * @LastEditTime: 2020-10-14 14:25:10
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/view/goods/curtain/widgets/window_style_option_view.dart';
import 'package:taojuwu/viewmodel/goods/binding/curtain/curtain_viewmodel.dart';

import '../sku_attr_picker.dart';

class WindowStyleOptionBar extends StatefulWidget {
  const WindowStyleOptionBar({Key key}) : super(key: key);

  @override
  _WindowStyleOptionBarState createState() => _WindowStyleOptionBarState();
}

class _WindowStyleOptionBarState extends State<WindowStyleOptionBar> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CurtainViewModel viewModel = Provider.of(context, listen: false);
        pickWindowStyleOption(context, viewModel);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: UIKit.height(16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // mainAxisSize,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Text(
                '窗型',
                style: TextStyle(color: const Color(0xFF333333), fontSize: 14),
              ),
              flex: 1,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    context.watch<CurtainViewModel>().windowStyleStr,
                    style: TextStyle(fontSize: 14, color: Color(0xFF1B1B1B)),
                  ),
                  Icon(
                    ZYIcon.next,
                    size: 20,
                  )
                ],
              ),
              flex: 4,
            )
          ],
        ),
      ),
    );
  }

  void pickWindowStyleOption(
      BuildContext ctx, CurtainViewModel viewModel) async {
    await showCupertinoModalPopup(
        context: ctx,
        builder: (BuildContext context) {
          return SkuAttrPicker(
            title: '窗型选择',
            child: SingleChildScrollView(
                child: Container(
              margin: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
              child: ListBody(
                children: [
                  WindowStyleOptionView('样式', options: viewModel.typeOptions),
                  WindowStyleOptionView('窗型选择', options: viewModel.bayOptions),
                  WindowStyleOptionView('窗帘盒', options: viewModel.boxOptions),
                ],
              ),
            )),
            callback: () {
              // provider?.saveWindowAttrs();

              // print(viewModel.mainImg);
              viewModel.refresh();
              Navigator.of(context).pop();
            },
          );
        });
  }
}
