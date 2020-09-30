/*
 * @Description: 属性选泽
 * @Author: iamsmiling
 * @Date: 2020-09-25 12:47:45
 * @LastEditTime: 2020-09-30 15:37:02
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/repository/shop/sku_attr/curtain_sku_attr.dart';

import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/view/goods/curtain/widgets/window_style_option_view.dart';
import 'package:taojuwu/viewmodel/goods/binding/curtain/curtain_viewmodel.dart';

import '../sku_attr_picker.dart';

/*
 * @Author: iamsmiling
 * @description: 为什么使用statefulwidget ---> 使用selector必须是不可变类型，不然页面无法刷新
 * @param : 
 * @return {type} 
 * @Date: 2020-09-29 10:13:16
 */
class WindowStyleOptionBar extends StatefulWidget {
  final CurtainSkuAttr skuAttr;
  final Function callback;
  const WindowStyleOptionBar(
    this.skuAttr, {
    Key key,
    this.callback,
  }) : super(key: key);

  @override
  _WindowStyleOptionBarState createState() => _WindowStyleOptionBarState();
}

class _WindowStyleOptionBarState extends State<WindowStyleOptionBar> {
  CurtainSkuAttr get skuAttr => widget.skuAttr;

  List<CurtainStyleOptionAttr> get attrList => skuAttr.styleOptionAttrs;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('--------');
        pickWindowStyleOption(context);
        // FocusManager.instance.primaryFocus.unfocus();
        // callback();
        // pickAttr(context);
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
                    context.watch<CurtainViewModel>().stylePatternMode,
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

  void refresh() {
    setState(() {});
  }

  void pickWindowStyleOption(BuildContext ctx) async {
    await showCupertinoModalPopup(
        context: ctx,
        builder: (BuildContext context) {
          return SkuAttrPicker(
            title: '窗型选择',
            child: SingleChildScrollView(
                child: Container(
              margin: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
              child: ListBody(
                children: List.generate(attrList.length ?? 0,
                    (index) => WindowStyleOptionView(attrList[index])),
              ),
            )),
            callback: () {
              // provider?.saveWindowAttrs();
              Navigator.of(context).pop();
            },
          );
        });
  }
  // void pickAttr(BuildContext ctx) async {
  //   await showCupertinoModalPopup(
  //       context: ctx,
  //       builder: (BuildContext context) {
  //         CurtainViewModel viewModel = Provider.of<CurtainViewModel>(ctx);
  //         return StatefulBuilder(
  //             builder: (BuildContext context, StateSetter setState) {
  //           return WillPopScope(
  //               child: SkuAttrPicker(
  //                   title: widget.skuAttr.title,
  //                   callback: () {
  //                     // dict[title]['confirm']();
  //                     refresh();
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: skuAttr.type == 1
  //                       ? _buildRoomAttrOptionView(setState)
  //                       : _buildCommonAttrOptionView(setState)),
  //               onWillPop: () {
  //                 if (!skuAttr.hasSelectedAttr) {
  //                   viewModel.resetAttr();
  //                 }
  //                 Navigator.of(context).pop();
  //                 return Future.value(false);
  //               });
  //         });
  //       });
  // }

  /*
   * @Author: iamsmiling
   * @description: 通用属性大的弹窗视图
   * @param : 
   * @return {type} 
   * @Date: 2020-09-29 10:58:30
   */

}
