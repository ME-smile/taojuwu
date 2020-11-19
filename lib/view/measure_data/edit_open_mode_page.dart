/*
 * @Description: 编辑打开方式的页面
 * @Author: iamsmiling
 * @Date: 2020-11-19 09:42:19
 * @LastEditTime: 2020-11-19 10:47:51
 */

import 'package:flutter/material.dart';
import 'package:taojuwu/repository/order/order_detail_model.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/base_curtain_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/style_selector/curtain_style_selector.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/view/goods/curtain/widgets/attrs/window_open_mode_option_bar.dart';
import 'package:taojuwu/widgets/zy_assetImage.dart';
import 'package:taojuwu/widgets/zy_submit_button.dart';

class EditOpenModePage extends StatefulWidget {
  final BaseCurtainProductDetailBean bean;
  EditOpenModePage(this.bean, {Key key}) : super(key: key);

  @override
  _EditOpenModePageState createState() => _EditOpenModePageState();
}

class _EditOpenModePageState extends State<EditOpenModePage> {
  BaseCurtainProductDetailBean get bean => widget.bean;
  CurtainStyleSelector get styleSelector => bean?.styleSelector;

  OrderGoodsMeasureData get measureData => bean?.measureData;

  @override
  void initState() {
    if (!CommonKit.isNullOrEmpty(measureData?.windowType)) {
      styleSelector.windowTypeBayBoxStr = measureData?.windowType;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('打开方式'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 320,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ZYAssetImage(
                      styleSelector.mainImg,
                    ),
                  ),
                ),
              ),
              Divider(),
              WindowOpenOptionBar(bean),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ZYSubmitButton('确认', () {
        measureData?.newOpenType = styleSelector.openModeStr;
        Navigator.of(context).pop();
      }),
    );
  }
}
