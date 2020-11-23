/*
 * @Description: 窗纱详情数据模型
 * @Author: iamsmiling
 * @Date: 2020-10-31 15:40:49
 * @LastEditTime: 2020-11-23 15:04:15
 */

import 'package:taojuwu/repository/shop/product_detail/abstract/abstract_base_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/base_curtain_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';
import 'package:taojuwu/services/otp_service.dart';

class GauzeCurtainProductDetailBean extends BaseCurtainProductDetailBean {
  GauzeCurtainProductDetailBean.fromJson(Map<String, dynamic> json)
      : super.fromJson(json);

  Future fetchAttrsData(Function refresh) async {
    List<Map<String, dynamic>> args = [
      {'type': 4, 'name': '工艺', 'title': '工艺选择'},
      {'type': 5, 'name': '型材', 'title': '型材更换'},
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
  void filter() {
    originAttrList ??= copyAttrs();
    String keyword0 = "单";
    String keyword1 = "GD";
    ProductSkuAttr craftAttr =
        originAttrList?.firstWhere((e) => e.type == 4, orElse: () => null);
    ProductSkuAttr partAttr =
        originAttrList?.firstWhere((e) => e.type == 5, orElse: () => null);
    craftSkuAttr?.data =
        craftAttr?.data?.where((e) => e.name.contains(keyword0))?.toList();
    partSkuAttr?.data =
        partAttr?.data?.where((e) => e?.name?.contains(keyword1))?.toList();
  }

  @override
  String get detailDescription =>
      '宽:${measureData?.widthM}米、高:${measureData?.heightM}米、${roomAttr?.selectedAttrName ?? ''}、${styleSelector.windowStyleStr ?? ''}、${styleSelector?.curInstallMode?.name ?? ''}、${styleSelector?.openModeStr ?? ''}、离地距离(cm):$deltaYCM';

  @override
  ProductType get productType => ProductType.GauzeCurtainProductType;

  @override
  double get totalPrice {
    double tmp = unitPrice;
    double heightFactor = 1.0;
    double mainHeightFactor = 1.0;
    if (heightCM != null && heightCM > 270) {
      heightFactor = 1.5;
      if (!isFixedHeight) {
        mainHeightFactor = (widthM + heightM - 2.65) / widthM;
      }
      tmp = unitPrice * widthM * mainHeightFactor * 2 +
          windowGauzePrice * 2 * widthM * heightFactor +
          partPrice * widthM +
          accessoriesPrice;
    }

    return tmp;
  }
}
