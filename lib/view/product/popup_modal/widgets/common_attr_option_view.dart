/*
 * @Description: 选择属性
 * @Author: iamsmiling
 * @Date: 2020-10-22 10:41:57
 * @LastEditTime: 2020-10-31 12:36:08
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product/curtain/base_curtain_product_bean.dart';
import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';
import 'package:taojuwu/view/goods/curtain/widgets/option_view.dart';

class CommonAttrOptionView extends StatefulWidget {
  final BaseCurtainProductBean bean;
  final List<ProductSkuAttrBean> list;
  CommonAttrOptionView(this.bean, this.list, {Key key}) : super(key: key);

  @override
  _CommonAttrOptionViewState createState() => _CommonAttrOptionViewState();
}

class _CommonAttrOptionViewState extends State<CommonAttrOptionView> {
  List<ProductSkuAttrBean> get list => widget.list;
  @override
  Widget build(BuildContext context) {
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
                childAspectRatio: 0.64,
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
        ));
  }
}
