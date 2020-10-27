/*
 * @Description: 空间属性选择视图
 * @Author: iamsmiling
 * @Date: 2020-10-22 10:38:16
 * @LastEditTime: 2020-10-23 17:31:39
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product/curtain/base_curtain_product_bean.dart';
import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';
import 'package:taojuwu/view/goods/curtain/widgets/option_view.dart';

class RoomAttrOptionView extends StatefulWidget {
  final BaseCurtainProductBean bean;
  final ProductSkuAttr attr;
  RoomAttrOptionView(this.bean, this.attr, {Key key}) : super(key: key);

  @override
  _RoomAttrOptionViewState createState() => _RoomAttrOptionViewState();
}

class _RoomAttrOptionViewState extends State<RoomAttrOptionView> {
  List<ProductSkuAttrBean> get list => widget.attr.data;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
        children: List.generate(list.length, (int i) {
          ProductSkuAttrBean bean = list[i];
          return OptionView(
            bean,
            isRoomAttr: true,
            callback: () {
              setState(() {
                widget.bean.selectAttrBean(widget.attr, i);
                // viewModel.selectAttrBean(skuAttr, i);
              });
            },
          );
        }),
      ),
    );
  }
}
