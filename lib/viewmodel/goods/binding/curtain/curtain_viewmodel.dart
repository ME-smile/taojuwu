/*
 * @Description: 商品模型
 * @Author: iamsmiling
 * @Date: 2020-09-25 15:57:46
 * @LastEditTime: 2020-11-19 15:00:47
 */
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taojuwu/repository/shop/product_bean.dart';
import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';
import 'package:taojuwu/repository/shop/sku_attr/window_style_sku_option.dart';
import 'package:taojuwu/repository/zy_response.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/utils/toast_kit.dart';
import 'package:taojuwu/viewmodel/goods/binding/curtain/binding/curtain_price_calculator_binding.dart';
import 'package:taojuwu/viewmodel/goods/binding/curtain/binding/curtain_style_selector_binding.dart';

import 'binding/curtain_price_calculator_binding.dart';

class CurtainViewModel extends CurtainPriceCalculatorBinding
    with CurtainStyleSelectorBinding {
  BuildContext mBuildContext;
  int id;

  bool isLoading = true;
  bool hasError = false;
  // 是否已经收藏过
  bool get hasLiked => bean?.isCollect == 1;
  String get measureDataStr =>
      '${curRoomSkuAttrBean?.name ?? ''}\n宽 ${measureData?.width ?? ''}米 高${measureData?.height ?? ''}米';

  set hasLiked(bool flag) {
    bean?.isCollect = flag ? 1 : 0;
  }

  CurtainViewModel.fromId(this.mBuildContext, this.id) {
    _fetchData();
  }

  CurtainViewModel.fromBean(ProductDetailBean productDetailBean) {
    bean = productDetailBean;
    // _initCurtainSkuAttr();

    print(styleSkuOption);
  }

  void _fetchData() {
    _initCurtainSkuAttr();
    _getCurtainDetail();
  }

  Future _initCurtainSkuAttr() {
    return rootBundle
        .loadString('assets/data/curtain.json')
        .then((String data) {
      Map json = jsonDecode(data);
      styleSkuOption = WindowStyleSkuOption.fromJson(json);
    }).catchError((err) {
      return err;
    });
  }

  Future _getCurtainDetail() async {
    // await OTPService.productDetail(mBuildContext, params: {'goods_id': 961})
    //     .then((ProductDetailBeanResp response) {
    //       bean = response?.data?.goodsDetail;
    //       relatedGoodsList = response?.data?.relatedGoodsList;
    //       sceneProjectList = response?.data?.sceneProjectList;
    //       softProjectList = response?.data?.softProjectList;
    //       recommendGoodsList = response?.data?.recommendGoodsList;
    //     })
    //     .catchError((err) => err)
    //     .whenComplete(() {
    //       isLoading = false;
    //       notifyListeners();
    //     });
    // isLoading = false;
    // notifyListeners();
  }

// 测装数据参数
  Map<String, dynamic> get mesaureDataArgs {
    return {
      'dataId': styleOptionId,
      'width': widthCM,
      'height': heightCM,
      'vertical_ground_height': deltaYCM,
      'goods_id': bean.goodsId,
      'install_room': curRoomSkuAttrBean?.id,
      '$styleOptionId': jsonEncode({
        'name': windowStyleStr,
        'selected': {
          '安装选项': [selectedInstallModeOption?.name ?? ''],
          '打开方式': openModeData
        }
      })
    };
  }

  // 打开方式参数
  get openModeData {
    //当前打开方式的名称
    String name = selectedOpenModeOption?.name ?? '';
    // 如果是 分墙体打开
    if (selectedOpenModeOption?.index == 2) {
      return {name: subOpenModeData};
    }
    return [name];
  }

  // 打开方式子选项数据
  Map<String, dynamic> get subOpenModeData {
    Map<String, dynamic> data = {};
    for (WindowOpenModeSubOption option in subOpenModeOptions) {
      List<WindowOpenModeSubOptionBean> list = option?.options;
      WindowOpenModeSubOptionBean bean = list?.firstWhere(
          (element) => element.isChecked,
          orElse: () => list?.first);
      data['${option?.title}'] = bean?.name;
    }
    return data;
  }

  // 属性参数
  Map<dynamic, dynamic> get attrArgs {
    Map<dynamic, dynamic> params = {};
    params.addAll(skuRoom?.toJson());
    for (ProductSkuAttr attr in skuList) {
      params.addAll(attr?.toJson());
    }
    return params;
  }

  //购物车参数构造
  Map<String, dynamic> get cartArgs {
    return {
      'client_uid': clientId,
      'wc_attr': attrArgs.toString(),
      'cart_detail': jsonEncode({
        'sku_id': bean?.skuId,
        'goods_id': bean?.goodsId,
        'goods_name': bean?.goodsName,
        'shop_id': bean?.shopId,
        'price': bean?.price,
        'picture': bean?.picture,
        'num': 1
      }),
      'measure_id': measureData?.id,
      'estimated_price': totalPrice,
    };
  }

  // beforeSaveMeasure
  bool beforeSaveMeasure() {
    if (clientId == null) {
      ToastKit.showInfo('请选择客户');
      return false;
    }
    if (!hasSetSize) {
      ToastKit.showInfo('请预填测装数据');
      return false;
    }
    return true;
  }

  //保存侧窗数据接口
  Future saveMeasure(BuildContext context) {
    if (!beforeSaveMeasure()) return Future.value(false);
    return OTPService.saveMeasure(context, params: mesaureDataArgs)
        .then((ZYResponse response) {
      if (response?.valid == true) {
        measureData?.id = CommonKit.parseInt(response?.data);
      }
    }).catchError((err) {
      return err;
    });
  }

  @override
  Future addToCart() async {
    // CommonKit.throttle(() => saveMeasure(context)
    //     .then((value) => value != false ? _addToCart() : ''));
    return saveMeasure(context)
        .then((value) => value != false ? _addToCart() : '');
  }

  Future _addToCart() {
    return OTPService.addCart(params: cartArgs)
        .then((ZYResponse response) {
          if (response?.valid == true) {
            ToastKit.showSuccessDIYInfo('加入购物车成功');
            goodsNumInCart = response?.data;
          } else {
            ToastKit.showErrorInfo(response?.message);
          }
        })
        .catchError((err) => err)
        .whenComplete(refresh);
  }

  //购买逻辑
  @override
  Future purchase() {
    return saveMeasure(context)
        .then((value) => value != false ? _purchase() : '');
  }

  Future _purchase() {
    return Future.value(0).then((value) => print('1234567'));
  }

  Map<String, dynamic> get data {
    return {
      'attr_list': attrsList,
      'room': skuRoom.toMap(),
    };
  }
}
