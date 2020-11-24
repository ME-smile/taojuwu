/*
 * @Description: 选择属性
 * @Author: iamsmiling
 * @Date: 2020-10-22 10:41:57
 * @LastEditTime: 2020-11-24 16:51:28
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/base_curtain_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';
import 'package:taojuwu/view/goods/curtain/widgets/option_view.dart';

class CommonAttrOptionView extends StatefulWidget {
  final BaseCurtainProductDetailBean bean;
  final ProductSkuAttr attr;

  CommonAttrOptionView(
    this.bean,
    this.attr, {
    Key key,
  }) : super(key: key);

  @override
  _CommonAttrOptionViewState createState() => _CommonAttrOptionViewState();
}

class _CommonAttrOptionViewState extends State<CommonAttrOptionView> {
  List<ProductSkuAttrBean> get list => widget.attr?.data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              //横轴间距
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 30.0,
              childAspectRatio: 0.64),
          itemCount: list.length,
          itemBuilder: (BuildContext context, int i) {
            ProductSkuAttrBean item = list[i];
            return Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: OptionView(
                item,
                callback: () {
                  setState(() {
                    // viewModel.selectAttrBean(widget.skuAttr, i);
                  });
                },
              ),
            );
          }),
    );
  }
}
