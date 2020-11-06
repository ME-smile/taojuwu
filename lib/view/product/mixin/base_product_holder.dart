/*
 * @Description: 
 * @Author: iamsmiling
 * @Date: 2020-10-28 14:36:00
 * @LastEditTime: 2020-11-05 10:57:30
 */
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:taojuwu/repository/shop/product_detail/abstract/base_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/abstract/single_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/design/scene_design_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/design/soft_design_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_bean.dart';
import 'package:taojuwu/services/otp_service.dart';

class BaseProductHolder {
  bool isLoading = true;
  SingleProductDetailBean productDetailBean;
  List<SingleProductDetailBean> relativeProductList;
  List<SceneDesignProductDetailBean> sceneDesignProductList;
  List<SoftDesignProductDetailBean> softDesignProductList;
  List<BaseProductDetailBean> recommendProductList;

  // 发起请求
  Future fetchData(BuildContext context, int goodsId) {
    return OTPService.productDetail(context, params: {'goods_id': goodsId})
        .then((ProductDetailBeanResp response) {
      productDetailBean = response?.data?.goodsDetail;
      relativeProductList = response?.data?.relativeProductList;
      sceneDesignProductList = response?.data?.sceneDesignProductList;
      softDesignProductList = response?.data?.softDesignProductList;
      recommendProductList = response?.data?.recommendProductList;
    }).catchError((err) => err);
  }

  void clear() {
    productDetailBean?.client = null;
  }
}
