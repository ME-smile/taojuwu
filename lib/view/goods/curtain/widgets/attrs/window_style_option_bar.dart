/*
 * @Description: 属性选泽
 * @Author: iamsmiling
 * @Date: 2020-09-25 12:47:45
 * @LastEditTime: 2020-10-22 15:48:50
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/repository/shop/product/curtain/fabric_curtain_product_bean.dart';
import 'package:taojuwu/repository/shop/product/curtain/style_selector/curtain_style_selector.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/view/goods/curtain/widgets/window_style_option_view.dart';

import '../sku_attr_picker.dart';

class WindowStyleOptionBar extends StatefulWidget {
  final FabricCurtainProductBean bean;
  final ValueNotifier<String> notifier; //用于更新图片
  const WindowStyleOptionBar(this.bean, {Key key, this.notifier})
      : super(key: key);

  @override
  _WindowStyleOptionBarState createState() => _WindowStyleOptionBarState();
}

class _WindowStyleOptionBarState extends State<WindowStyleOptionBar> {
  CurtainStyleSelector get styleSelector => widget?.bean?.styleSelector;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // CurtainViewModel viewModel = Provider.of(context, listen: false);
        pickWindowStyleOption(context, widget.bean);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
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
                    styleSelector?.windowStyleStr,
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

  Future pickWindowStyleOption(
      BuildContext ctx, FabricCurtainProductBean bean) async {
    return showCupertinoModalPopup(
        context: ctx,
        builder: (BuildContext context) {
          return SkuAttrPicker(
            title: '窗型选择',
            child: SingleChildScrollView(
                child: Container(
              margin: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
              child: ListBody(
                children: [
                  WindowStyleOptionView('样式',
                      options: styleSelector.typeOptions),
                  WindowStyleOptionView('窗型选择',
                      options: styleSelector.bayOptions),
                  WindowStyleOptionView('窗帘盒',
                      options: styleSelector.boxOptions),
                ],
              ),
            )),
            callback: () {
              // provider?.saveWindowAttrs();

              // print(viewModel.mainImg);
              widget.notifier?.value = styleSelector.mainImg;
              Navigator.of(context).pop();
            },
          );
        }).then((value) {
      setState(() {});
    });
  }
}
