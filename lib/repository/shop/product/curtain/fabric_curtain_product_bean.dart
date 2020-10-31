/*
 * @Description: 布艺帘商品
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:12:26
 * @LastEditTime: 2020-10-31 12:13:33
 */

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product/abstract/abstract_base_product_bean.dart';
import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/toast_kit.dart';

import 'base_curtain_product_bean.dart';

class FabricCurtainProductBean extends BaseCurtainProductBean {
  FabricCurtainProductBean.fromJson(Map<String, dynamic> json)
      : super.fromJson(json);

  ///[refresh]刷新页面的回调函数 在数据返回时刷新页面
  // 获取属性相关的数据
  Future fetchAttrsData(Function refresh) async {
    List<Map<String, dynamic>> args = [
      {
        'type': 3,
        'name': '窗纱',
        'title': '窗纱选择',
      },
      {'type': 4, 'name': '工艺', 'title': '工艺选择'},
      {'type': 5, 'name': '型材', 'title': '型材更换'},
      {'type': 8, 'name': '幔头', 'title': '幔头选择'},
      {'type': 12, 'name': '里布', 'title': '里布选择'},
      {'type': 13, 'name': '配饰', 'title': '配饰选择'}
    ];

    List<Future<ProductSkuAttrWrapperResp>> futures = args.map((e) {
      e.addAll({
        'parts_type': measureData?.partsType,
        'goods_id': goodsId,
      });
      return OTPService.skuAttr(params: e)
          .then((ProductSkuAttrWrapperResp response) {
        if (response?.valid == true) {
          attrList?.add(response?.data);
        }
      }).catchError((err) => err);
    }).toList();
    await Future.wait(futures);
    attrList?.sort((ProductSkuAttr a, ProductSkuAttr b) => a.type - b.type);
    // ignore: unnecessary_statements
    refresh == null ? '' : refresh();
  }

  @override
  double get totalPrice {
    // 配饰价格计算 acc-->accesspry
    double tmp = unitPrice;
    double heightFactor = 1.0;
    double mainHeightFactor = 1.0;
    if (heightCM != null && heightCM > 270) {
      heightFactor = 1.5;
      if (!isFixedHeight) {
        mainHeightFactor = (widthM + heightM - 2.65) / widthM;
      }
      //如果窗纱存在
      if (hasWindowGauze) {
        tmp = unitPrice * widthM * mainHeightFactor * 2 +
            (windowShadeClothPrice + windowGauzePrice) *
                2 *
                widthM *
                heightFactor +
            canopyPrice * widthM +
            partPrice * widthM * 2 +
            accessoriesPrice;
      }
    } else {
      tmp = unitPrice * widthM * mainHeightFactor * 2 +
          (windowShadeClothPrice + windowGauzePrice) *
              2 *
              widthM *
              heightFactor +
          canopyPrice * widthM +
          partPrice * widthM +
          accessoriesPrice;
    }

    return tmp;
  }

  int get styleOptionId => styleSelector?.styleOptionId;

  //窗帘样式
  String get windowStyleStr => styleSelector?.windowStyleStr;
  // 测装数据参数
  @override
  Map<String, dynamic> get mesaureDataArg {
    return {
      'dataId': styleOptionId,
      'width': widthCM,
      'height': heightCM,
      'vertical_ground_height': deltaYCM,
      'goods_id': goodsId,
      'install_room': roomAttr?.selcetedAttrBean?.id,
      // 'install_room': roomAttr?.selcetedAttrBean?.id,
      'data': jsonEncode({
        '$styleOptionId': {
          'name': windowStyleStr,
          "install_room": "0",
          'w': '$widthCM',
          'h': '$heightCM',
          '13': attrList?.last?.toJson(),
          'selected': {
            '安装选项': [styleSelector?.curInstallMode?.name ?? ''],
            '打开方式': styleSelector?.openModeData
          }
        }
      })
    };
  }

  @override
  Future addToCart(BuildContext context) {
    return hasSetSize
        ? saveMeasure(context)
            .then((value) => value != false ? addToCartRequest() : '')
        : Future.value(false);
  }

  @override
  Future buy(BuildContext context) {
    return hasSetSize
        ? saveMeasure(context)
            .then((value) => value != false ? super.buy(context) : '')
        : Future.value(false);
    // throw UnimplementedError();
  }

  bool get hasSetSize {
    if (measureData?.hasSetSize == false) {
      ToastKit.showInfo('请先填写测装数据哦');
      return false;
    }
    return true;
  }

  @override
  get cartArgs => {
        // 'measure_data': mesaureDataArg,
        'wc_attr': jsonEncode(attrArgs),
        'measure_id': measureData?.id,
        'estimated_price': totalPrice,
        'client_uid': clientId,
        'is_shade': 1,
        'cart_detail': jsonEncode({
          'sku_id': '$skuId',
          'goods_id': '$goodsId',
          'goods_name': '$goodsName',
          'shop_id': '$shopId',
          'price': '$price',
          'picture': '$picture',
          'num': '$count',
        })
      };

  @override
  ProductType get productType => ProductType.FabricCurtainProductType;

  String get detailDescription {
    return '宽:${widthMStr ?? ''}米 高:${heightMStr ?? ''}米、${roomAttr?.selectedAttrName ?? ''}、${styleSelector?.windowStyleStr ?? ''}、${styleSelector?.curInstallMode?.name ?? ''}、${styleSelector?.openModeStr ?? ''}';
  }
}
