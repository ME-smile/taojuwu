/*
 * @Description: 声明一个mixin的类，拥有计算商品价格的功能
 * @Author: iamsmiling
 * @Date: 2020-09-27 09:06:14
 * @LastEditTime: 2020-09-30 17:19:10
 */

import 'package:taojuwu/viewmodel/goods/binding/base/curtain_goods_binding.dart';
import 'package:taojuwu/viewmodel/goods/binding/curtain/binding/curtain_sepc_binding.dart';
import 'package:taojuwu/viewmodel/goods/binding/curtain/binding/curtain_size_filler_binding.dart';

class CurtainPriceCalculatorBinding extends CurtainGoodsBinding
    with CurtainSpecBinding, CurtainSizeFillerBinding {
  // 商品单价
  double get unitPrice {
    return bean?.price ?? 0.00;
  }

  // 窗纱的价格
  double get windowGauzePrice {
    // if (goods.goodsSpecialType == 1) return 0.0
    return curWindowGauzeAttrBean?.price ?? 0.0;
  }

  // 型材的价格
  double get partPrice {
    // if (goods.goodsSpecialType == 1) return 0.0;
    return curPartAttrBean?.price ?? 0.0;
  }

  // 里布的价格
  double get windowShadeClothPrice {
    return curWindowShadeAttrBean?.price ?? 0.0;
  }

  // 幔头的价格
  double get canopyPrice {
    // if (goods.goodsSpecialType == 1) return 0.0;
    return curCanopyAttrBean?.price ?? 0.0;
  }

  // 配饰的价格
  double get accessoriesPrice {
    double tmp = 0.0;
    selectedAccessoryBeans?.forEach((element) {
      tmp += element.price;
    });
    return tmp;
  }

  @override
  //总价
  double get totalPrice {
    double tmp = unitPrice;

    // 卷帘
    if (isWindowRoller) return unitPrice * area;

    // 配饰价格计算 acc-->accesspry
    double heightFactor = 1.0;
    double mainHeightFactor = 1.0;
    if (heightCM > 270) {
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
}
