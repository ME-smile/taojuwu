/*
 * @Description: 
 * @Author: iamsmiling
 * @Date: 2020-10-28 14:36:00
 * @LastEditTime: 2020-10-31 06:40:05
 */
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:taojuwu/repository/shop/product/abstract/base_product_bean.dart';
import 'package:taojuwu/repository/shop/product/abstract/single_product_bean.dart';
import 'package:taojuwu/repository/shop/product/design/scene_design_product_bean.dart';
import 'package:taojuwu/repository/shop/product/design/soft_design_product_bean.dart';
import 'package:taojuwu/repository/shop/product/relative_product/relative_product_bean.dart';
import 'package:taojuwu/repository/shop/product_bean.dart';
import 'package:taojuwu/services/otp_service.dart';

class BaseProductHolder {
  bool isLoading = true;
  SingleProductBean productBean;
  List<RelativeProductBean> relativeProductList;
  List<SceneDesignProductBean> sceneDesignProductList;
  List<SoftDesignProductBean> softDesignProductList;
  List<BaseProductBean> recommendProductList;

  // 发起请求
  Future fetchData(BuildContext context, int goodsId) {
    return OTPService.productDetail(context, params: {'goods_id': goodsId})
        .then((ProductBeanResp response) {
      productBean = response?.data?.goodsDetail;
      relativeProductList = response?.data?.relativeProductList;
      sceneDesignProductList = response?.data?.sceneDesignProductList;
      softDesignProductList = response?.data?.softDesignProductList;
      recommendProductList = response?.data?.recommendProductList;
    }).catchError((err) => err);
  }

  void clear() {
    productBean?.client = null;
  }
}
