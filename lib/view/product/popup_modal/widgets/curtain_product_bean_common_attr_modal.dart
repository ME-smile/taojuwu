/*
 * @Description: 窗帘通用属性选取
 * @Author: iamsmiling
 * @Date: 2020-10-26 10:55:49
 * @LastEditTime: 2020-10-26 11:03:23
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product/curtain/base_curtain_product_bean.dart';
import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';
import 'package:taojuwu/view/goods/curtain/widgets/option_view.dart';

class CurtainProductBeanCommonAttrModal extends StatefulWidget {
  final BaseCurtainProductBean bean;
  final ProductSkuAttr attr;
  CurtainProductBeanCommonAttrModal(this.bean, this.attr, {Key key})
      : super(key: key);

  @override
  _CurtainProductBeanCommonAttrModalState createState() =>
      _CurtainProductBeanCommonAttrModalState();
}

class _CurtainProductBeanCommonAttrModalState
    extends State<CurtainProductBeanCommonAttrModal> {
  BaseCurtainProductBean get bean => widget.bean;
  ProductSkuAttr get attr => widget.attr;
  List<ProductSkuAttrBean> get list => widget.attr?.data;
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
                childAspectRatio: 0.72,
              ),
              itemCount: list.length ?? 0,
              itemBuilder: (BuildContext context, int i) {
                ProductSkuAttrBean item = list[i];
                return OptionView(
                  item,
                  callback: () {
                    setState(() {
                      bean.selectAttrBean(attr, i);
                    });
                  },
                );
              }),
        ));
  }
}
