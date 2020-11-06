/*
 * @Description: 修改窗帘商品属性叶脉你
 * @Author: iamsmiling
 * @Date: 2020-10-26 13:04:29
 * @LastEditTime: 2020-11-06 14:00:22
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/base_curtain_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';
import 'package:taojuwu/view/goods/curtain/widgets/attrs/attr_options_bar.dart';
import 'package:taojuwu/widgets/zy_raised_button.dart';

class EditCurtainProductAttrPage extends StatefulWidget {
  final BaseCurtainProductDetailBean bean; //属性列表
  EditCurtainProductAttrPage(this.bean, {Key key}) : super(key: key);

  @override
  _EditCurtainProductAttrPageState createState() =>
      _EditCurtainProductAttrPageState();
}

class _EditCurtainProductAttrPageState
    extends State<EditCurtainProductAttrPage> {
  BaseCurtainProductDetailBean get bean => widget.bean;
  List<ProductSkuAttr> get list => bean?.attrList;

  List<ProductSkuAttr> originAttrList;

  //备份未修改前的数据，在直接返回时，重新指向
  @override
  void initState() {
    originAttrList = bean?.attrList;
    bean?.attrList = originAttrList?.map((e) => e?.copy())?.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        bean?.attrList = originAttrList;
        return Future.value(true);
      },
      child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            title: Text('修改属性'),
            centerTitle: true,
          ),
          body: ListView.separated(
              itemBuilder: (BuildContext context, int i) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: AttrOptionsBar(bean, list[i]),
                );
              },
              separatorBuilder: (BuildContext context, int i) {
                return Divider(
                  indent: 16,
                  endIndent: 16,
                  height: 1,
                );
              },
              itemCount: list?.length ?? 0),
          bottomNavigationBar: Container(
            padding: EdgeInsets.symmetric(horizontal: 48, vertical: 8),
            child: ZYRaisedButton(
              '确定',
              () {
                Navigator.of(context).pop();
              },
              verticalPadding: 12,
            ),
          )),
    );
  }
}
