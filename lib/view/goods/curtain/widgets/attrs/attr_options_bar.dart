/*
 * @Description: 属性选泽
 * @Author: iamsmiling
 * @Date: 2020-09-25 12:47:45
 * @LastEditTime: 2020-09-30 17:37:15
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';

import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/viewmodel/goods/binding/curtain/curtain_viewmodel.dart';

import '../option_view.dart';
import '../sku_attr_picker.dart';

/*
 * @Author: iamsmiling
 * @description: 为什么使用statefulwidget ---> 使用selector必须是不可变类型，不然页面无法刷新
 * @param : 
 * @return {type} 
 * @Date: 2020-09-29 10:13:16
 */
class AttrOptionsBar extends StatefulWidget {
  final int index; // 在skulist中的索引位置
  final GoodsSkuAttr skuAttr;
  final Function callback;
  const AttrOptionsBar(this.skuAttr, {Key key, this.callback, this.index = 0})
      : super(key: key);

  @override
  _AttrOptionsBarState createState() => _AttrOptionsBarState();
}

class _AttrOptionsBarState extends State<AttrOptionsBar> {
  bool get isVisible => ![1, 2].contains(skuAttr.type);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // FocusManager.instance.primaryFocus.unfocus();
        // callback();
        pickAttr(context);
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
                widget.skuAttr.name,
                style: TextStyle(color: const Color(0xFF333333), fontSize: 14),
              ),
              flex: 1,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    widget.skuAttr.selectedAttrName,
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

  GoodsSkuAttr get skuAttr => widget.skuAttr;

  Future pickAttr(BuildContext ctx) {
    return showCupertinoModalPopup(
        context: ctx,
        builder: (BuildContext context) {
          CurtainViewModel viewModel = Provider.of<CurtainViewModel>(ctx);
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return WillPopScope(
                child: SkuAttrPicker(
                    title: widget.skuAttr.title,
                    callback: () {
                      refresh();
                      viewModel.refresh();
                      Navigator.of(context).pop();
                    },
                    child: skuAttr.type == 1
                        ? _buildRoomAttrOptionView(setState)
                        : _buildCommonAttrOptionView(setState)),
                onWillPop: () {
                  if (!skuAttr.hasSelectedAttr) {
                    viewModel.resetAttr();
                  }

                  Navigator.of(context).pop();
                  return Future.value(false);
                });
          });
        });
  }

  /*
   * @Author: iamsmiling
   * @description: 通用属性大的弹窗视图
   * @param : 
   * @return {type} 
   * @Date: 2020-09-29 10:58:30
   */
  Widget _buildCommonAttrOptionView(StateSetter setState) {
    CurtainViewModel viewModel =
        Provider.of<CurtainViewModel>(context, listen: false);
    return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                //横轴间距
                crossAxisSpacing: 10.0,
                childAspectRatio: 0.72,
              ),
              itemCount: widget.skuAttr.data.length,
              itemBuilder: (BuildContext context, int i) {
                GoodsSkuAttrBean item = widget.skuAttr.data[i];
                return OptionView(
                  item,
                  callback: () {
                    setState(() {
                      viewModel.selectAttrBean(widget.skuAttr, i);
                    });
                  },
                );
              }),
        ));
  }

  /*
   * @Author: iamsmiling
   * @description: 选择空间时的弹窗视图
   * @param : 
   * @return {type} 
   * @Date: 2020-09-29 10:58:54
   */
  Widget _buildRoomAttrOptionView(StateSetter setState) {
    CurtainViewModel viewModel =
        Provider.of<CurtainViewModel>(context, listen: false);
    List list = skuAttr.data;
    return SingleChildScrollView(
      child: Wrap(
        children: List.generate(list.length, (int i) {
          GoodsSkuAttrBean bean = list[i];
          return OptionView(
            bean,
            isRoomAttr: true,
            callback: () {
              setState(() {
                viewModel.selectAttrBean(skuAttr, i);
              });
            },
          );
        }),
      ),
    );
  }
}
