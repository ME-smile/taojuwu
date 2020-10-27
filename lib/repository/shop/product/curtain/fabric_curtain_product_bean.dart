/*
 * @Description: 布艺帘商品
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:12:26
 * @LastEditTime: 2020-10-27 16:41:29
 */

import 'dart:convert';

import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';
import 'package:taojuwu/services/otp_service.dart';

import 'base_curtain_product_bean.dart';
import 'style_selector/curtain_style_selector.dart';

class FabricCurtainProductBean extends BaseCurtainProductBean {
  CurtainStyleSelector styleSelector =
      CurtainStyleSelector(); // 样式选择  只有布艺帘才需要选择 这些属性

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
  Map<String, dynamic> get mesaureDataArg {
    return {
      'dataId': styleOptionId,
      'width': widthCM,
      'height': heightCM,
      'vertical_ground_height': deltaYCM,
      'goods_id': goodsId,
      'install_room': roomAttr?.selcetedAttrBean?.id,
      '$styleOptionId': jsonEncode({
        'name': windowStyleStr,
        'selected': {
          '安装选项': [styleSelector?.curInstallMode?.name ?? ''],
          '打开方式': styleSelector?.openModeData
        }
      })
    };
  }

  @override
  Future addToCart() {
    // TODO: implement addToCart
    throw UnimplementedError();
  }

  @override
  Future buy() {
    print(attrArgs);
    print(mesaureDataArg);
    return Future.value(false);
    // throw UnimplementedError();
  }

  @override
  get cartArgs => {
        'measure_data': mesaureDataArg,
        'wc_attr': attrArgs,
        'sku_id': '$skuId',
        'goods_id': '$goodsId',
        'goods_name': '$goodsName',
        'shop_id': '$shopId',
        'picture': '$picture',
        'num': '$count',
        'estimated_price': totalPrice
      };
}
