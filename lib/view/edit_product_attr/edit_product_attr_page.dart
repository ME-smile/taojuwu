/*
 * @Description: 修改窗帘商品属性叶脉你
 * @Author: iamsmiling
 * @Date: 2020-10-26 13:04:29
 * @LastEditTime: 2020-10-26 13:18:04
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product/curtain/base_curtain_product_bean.dart';
import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';
import 'package:taojuwu/view/goods/curtain/widgets/attrs/attr_options_bar.dart';

class EditCurtainProductAttrPage extends StatefulWidget {
  final BaseCurtainProductBean bean; //属性列表
  EditCurtainProductAttrPage(this.bean, {Key key}) : super(key: key);

  @override
  _EditCurtainProductAttrPageState createState() =>
      _EditCurtainProductAttrPageState();
}

class _EditCurtainProductAttrPageState
    extends State<EditCurtainProductAttrPage> {
  BaseCurtainProductBean get bean => widget.bean;
  List<ProductSkuAttr> get list => bean?.attrList;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text('修改属性'),
            centerTitle: true,
          ),
          body: ListView.separated(
              itemBuilder: (BuildContext context, int i) {
                return AttrOptionsBar(bean, list[i]);
              },
              separatorBuilder: (BuildContext context, int i) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                    indent: 16,
                    endIndent: 16,
                    thickness: 1,
                    height: 1,
                  ),
                );
              },
              itemCount: list?.length ?? 0),
        ),
        onWillPop: () {
          Navigator.of(context).pop();
          return Future.value(false);
        });
  }
}
