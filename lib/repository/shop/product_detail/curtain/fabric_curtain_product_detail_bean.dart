/*
 * @Description: 布艺帘商品
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:12:26
 * @LastEditTime: 2020-12-22 10:20:07
 */

import 'package:taojuwu/repository/shop/product_detail/abstract/abstract_base_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/common_kit.dart';

import 'base_curtain_product_detail_bean.dart';

class FabricCurtainProductDetailBean extends BaseCurtainProductDetailBean {
  bool hasFlower; // 窗帘是否有拼花
  bool isFixedHeight; // 窗帘是否定高
  bool isFixedWidth; //窗帘是否定宽
  bool isCustomSize; //自定义宽高
  double doorWidth; //门幅
  double flowerSize; //花距
  FabricCurtainProductDetailBean.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    hasFlower = json['is_flower'] == 1;
    isFixedHeight = json['fixed_height'] == 1;
    isFixedWidth = json['fixed_height'] == 2;
    isCustomSize = json['fixed_height'] == 3;
    doorWidth =
        CommonKit.parseDouble(json['larghezza_size'], defaultVal: 0.0) / 100;
    flowerSize =
        CommonKit.parseDouble(json['flower_distance'], defaultVal: 0.0) / 100;
  }

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

  // 褶皱系数
  double get foldingFactor => 2.0;

  @override
  double get totalPrice {
    // 配饰价格计算 acc-->accesspry
    double tmp = unitPrice;

    //如果窗纱存在
    if (hasWindowGauze) {
      tmp = mainCurtainClothPrice +
          (windowShadeClothPrice + windowGauzePrice) *
              2 *
              widthM *
              heightFactor +
          canopyPrice * widthM +
          partPrice * widthM * 2 +
          accessoriesPrice;
    } else {
      tmp = mainCurtainClothPrice +
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

  //窗帘主布价格计算
  double get mainCurtainClothPrice {
    if (isFixedHeight) {
      return widthM * foldingFactor * heightFactor * unitPrice;
    }
    if (isFixedWidth) {
      if (hasFlower) {
        return unitPrice *
            ((widthM * foldingFactor / doorWidth).ceil() *
                ((heightM + 0.2) / flowerSize).ceil() *
                flowerSize);
      }

      return unitPrice *
          ((widthM * foldingFactor / doorWidth).ceil() * ((heightM + 0.2)));
    }

    return widthM * foldingFactor * mainHeightFactor * unitPrice;
  }

  //窗帘主布高度因子
  double get mainHeightFactor {
    double factor = 1.0;
    if ((heightCM != null && heightCM > 276) && isCustomSize) {
      factor = (widthM + heightM - 2.65) / widthM;
    }
    return factor;
  }

  // 窗帘高度因子2
  double get heightFactor {
    return heightCM != null && heightCM > 276 ? 1.5 : 1.0;
  }

  @override
  ProductType get productType => ProductType.FabricCurtainProductType;

  String get detailDescription {
    return '宽:${widthMStr ?? ''}米 高:${heightMStr ?? ''}米、${roomAttr?.selectedAttrName ?? ''}、${styleSelector?.windowStyleStr ?? ''}、${styleSelector?.curInstallMode?.name ?? ''}、${styleSelector?.openModeStr ?? ''}';
  }
}
