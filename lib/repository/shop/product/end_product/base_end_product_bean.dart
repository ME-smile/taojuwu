/*
 * @Description: 所有成品商品的基类
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:17:00
 * @LastEditTime: 2020-11-04 09:41:37
 */
import 'package:taojuwu/application.dart';
import 'package:taojuwu/event_bus/events/add_to_cart_event.dart';
import 'package:taojuwu/repository/shop/product/base/spec/product_spec_bean.dart';
import 'package:taojuwu/repository/shop/product_sku_bean.dart';
import 'package:taojuwu/repository/zy_response.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/utils/toast_kit.dart';

import 'abstract_base_end_product_bean.dart';

abstract class BaseEndProductBean extends AbstractBaseEndProductBean {
  List<ProductSpecBean> specList;
  BaseEndProductBean.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    specList = CommonKit.parseList(json['spec_list'])
        ?.map((e) => ProductSpecBean.fromJson(e))
        ?.toList();
  }

  Future addToCartRequest() {
    return OTPService.addCart(params: cartArgs).then((ZYResponse response) {
      if (response?.valid == true) {
        ToastKit.showSuccessDIYInfo('加入购物车成功');
        Application.eventBus.fire(AddToCartEvent(response?.data));
      } else {
        ToastKit.showErrorInfo(response?.message);
      }
    }).catchError((err) => err);
  }

  ProductSkuBean get currentSkuBean =>
      skuList?.firstWhere((element) => element?.skuName == selectedOptionsName,
          orElse: () => null);

  int get skuId => currentSkuBean?.skuId;

  int get picId => currentSkuBean?.picId;

  String get mainImg => currentSkuBean?.image;

  String get selectedOptionsName =>
      specList?.map((e) => e?.selectedOptionsName)?.toList()?.join(' ') ?? '';

  void selectSpecOption(ProductSpecBean spec, ProductSpecOptionBean option) {
    spec?.options?.forEach((el) {
      el?.isSelected = el == option;
    });
  }

  String get detailDescription {
    List<String> list = [];
    specList?.forEach((el) {
      String selectedOptionName = el?.options
              ?.firstWhere((o) => o?.isSelected, orElse: () => null)
              ?.name ??
          '';
      list.add('${el.name}: $selectedOptionName ');
    });
    return list.join(',');
  }
}
