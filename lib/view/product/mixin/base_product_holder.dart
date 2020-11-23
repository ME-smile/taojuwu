/*
 * @Description: 
 * @Author: iamsmiling
 * @Date: 2020-10-28 14:36:00
 * @LastEditTime: 2020-11-22 13:32:48
 */
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:taojuwu/repository/order/order_detail_model.dart';
import 'package:taojuwu/repository/shop/product_detail/abstract/base_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/abstract/single_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/base_curtain_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/rolling_curtain_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/design/scene_design_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/design/soft_design_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_bean.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/view/product/mixin/target_product_holder.dart';

class BaseProductHolder {
  bool isLoading = true;
  bool hasError = false;
  SingleProductDetailBean productDetailBean;
  List<SingleProductDetailBean> relativeProductList;
  List<SceneDesignProductDetailBean> sceneDesignProductList;
  List<SoftDesignProductDetailBean> softDesignProductList;
  List<BaseProductDetailBean> recommendProductList;

  // 发起请求
  Future fetchData(BuildContext context, int goodsId,
      {bool isMeasureOrderGoods = false}) {
    hasError = false;
    return OTPService.productDetail(context, params: {
      'goods_id': goodsId,
      'go_selection': isMeasureOrderGoods ? '1' : ''
    }).then((ProductDetailBeanResp response) {
      productDetailBean = response?.data?.goodsDetail;
      relativeProductList = response?.data?.relativeProductList;
      sceneDesignProductList = response?.data?.sceneDesignProductList;
      softDesignProductList = response?.data?.softDesignProductList;
      recommendProductList = response?.data?.recommendProductList;
      updateMeasureData();
    }).catchError((err) => err);
  }

  void updateMeasureData() {
    if (productDetailBean is BaseCurtainProductDetailBean) {
      (productDetailBean as BaseCurtainProductDetailBean).measureData =
          TargetProductHolder.measureData ?? OrderGoodsMeasureData();
      if (productDetailBean is RollingCurtainProductDetailBean) {
        (productDetailBean as BaseCurtainProductDetailBean)
            .measureData
            ?.hasConfirmed = true;
        print(TargetProductHolder.measureData?.orderGoodsId);
        print((productDetailBean as BaseCurtainProductDetailBean)
            .measureData
            .orderGoodsId);
        print('________++++++++');
      }
    }
  }

  void clear() {
    // productDetailBean?.client = null;
  }
}
