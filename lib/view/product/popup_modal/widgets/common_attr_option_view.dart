/*
 * @Description: 选择属性
 * @Author: iamsmiling
 * @Date: 2020-10-22 10:41:57
 * @LastEditTime: 2020-11-19 15:20:42
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/base_curtain_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';
import 'package:taojuwu/view/goods/curtain/widgets/option_view.dart';

class CommonAttrOptionView extends StatefulWidget {
  final BaseCurtainProductDetailBean bean;
  final List<ProductSkuAttrBean> list;

  CommonAttrOptionView(
    this.bean,
    this.list, {
    Key key,
  }) : super(key: key);

  @override
  _CommonAttrOptionViewState createState() => _CommonAttrOptionViewState();
}

class _CommonAttrOptionViewState extends State<CommonAttrOptionView> {
  List<ProductSkuAttrBean> get list => widget.list;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.only(bottom: 32),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            //横轴间距
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 2,
            childAspectRatio: 0.5,
          ),
          itemCount: list.length,
          itemBuilder: (BuildContext context, int i) {
            ProductSkuAttrBean item = list[i];
            return OptionView(
              item,
              callback: () {
                setState(() {
                  // viewModel.selectAttrBean(widget.skuAttr, i);
                });
              },
            );
          }),
    );
  }
}
