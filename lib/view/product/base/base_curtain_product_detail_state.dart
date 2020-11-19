/*
 * @Description: 窗帘样式混入
 * @Author: iamsmiling
 * @Date: 2020-10-31 06:31:55
 * @LastEditTime: 2020-11-19 13:05:07
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/order/order_detail_model.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/base_curtain_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/rolling_curtain_product_detail_bean.dart';
import 'package:taojuwu/view/product/mixin/measure_data_holder.dart';
import 'package:taojuwu/view/product/mixin/product_attr_holder.dart';
import 'package:taojuwu/view/product/mixin/style_selector_holder.dart';
import 'package:taojuwu/view/product/mixin/target_product_holder.dart';

import 'base_product_detail_state.dart';

class BaseCurtainProductDetailState<T> extends BaseProductDetailPageState<T>
    with StyleSelectorHolder, MeasureDataHolder, ProductAttrHolder {
  BaseCurtainProductDetailBean get curtainProductDetailBean =>
      (productDetailBean as BaseCurtainProductDetailBean);
  ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();

    super.initState();
  }

  void scrollToTop() {
    scrollController?.animateTo(0,
        duration: Duration(milliseconds: 375), curve: Curves.bounceInOut);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController?.dispose();
  }

  void copyData() {
    roomAttr = curtainProductDetailBean?.roomAttr;
    attrList = curtainProductDetailBean?.attrList;
    measureData = curtainProductDetailBean?.measureData;
    styleSelector = curtainProductDetailBean?.styleSelector;
  }

  @override
  Future sendRequest() {
    return super.sendRequest().whenComplete(() {
      if (curtainProductDetailBean?.measureData?.orderGoodsId != null) {
        curtainProductDetailBean?.craftSkuAttr?.data = curtainProductDetailBean
            ?.filterCraft(curtainProductDetailBean?.craftSkuAttr?.data);

        setState(() {});
      }
    });
  }

  void updateMeasureData() {
    if (productDetailBean is BaseCurtainProductDetailBean) {
      (productDetailBean as BaseCurtainProductDetailBean).measureData =
          TargetProductHolder.measureData ?? OrderGoodsMeasureData();
      if (productDetailBean is RollingCurtainProductDetailBean) {
        (productDetailBean as BaseCurtainProductDetailBean)
            .measureData
            ?.hasConfirmed = true;
        print('+++++++${measureData?.hasConfirmed}');
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}
