/*
 * @Description: 复合商品
 * @Author: iamsmiling
 * @Date: 2020-10-19 10:00:54
 * @LastEditTime: 2020-10-23 15:46:19
 */
import 'package:flutter/cupertino.dart';
import 'package:taojuwu/repository/shop/product_bean.dart';
import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';
import 'package:taojuwu/repository/shop/soft_project_bean.dart';
import 'package:taojuwu/viewmodel/goods/binding/base/base_goods_viewmodel.dart';
import 'package:taojuwu/viewmodel/goods/binding/curtain/curtain_viewmodel.dart';

//此类具有页面刷新的功能
class MixinGoodsViewModel extends BaseGoodsViewModel {
  final int scenesId; //场景id
  BaseGoodsViewModel currentGoodsViewModel; //当前商品详情的viewmodel 模型
  final BuildContext context;

  List<SoftProjectGoodsBean> goodsList = [];

  int get currentGoodsId => currentGoodsViewModel?.goodsId;

  bool get currentGoodsIsEndProduct =>
      currentGoodsViewModel?.bean?.isEndProduct ?? false;

  MixinGoodsViewModel(this.context, this.scenesId, this.currentGoodsViewModel) {
    _fetchData();
  }

  _fetchData() {
    // OTPService.softDetail(context, params: {'scenes_id': 44})
    //     .then((SoftProjectDetailBeanResp response) {
    //       if (response?.valid == true) {
    //         bean = response?.data;
    //         goodsList = bean?.goodsList;
    //         if (currentGoodsViewModel?.bean?.isEndProduct == false) {
    //           goodsList.forEach((el) {
    //             if (el?.isEndProduct == false) {
    //               el.attrList = (currentGoodsViewModel as CurtainViewModel)
    //                   .attrsList
    //                   ?.map((e) => ProductSkuAttr.fromJson(e))
    //                   ?.toList();
    //               // el?.roomAttr = ProductSkuAttr.fromJson(
    //               //     (currentGoodsViewModel as CurtainViewModel).roomAttr);
    //             }
    //           });
    //         }
    //       }
    //     })
    //     .catchError((err) => err)
    //     .whenComplete(() {
    //       notifyListeners();
    //     });
  }

  @override
  Future addToCart() {
    // TODO: implement addToCart
    throw UnimplementedError();
  }

  @override
  Future purchase() {
    // TODO: implement purchase
    throw UnimplementedError();
  }

  @override
  // TODO: implement totalPrice
  double get totalPrice => throw UnimplementedError();
}

extension SoftProjectGoodsKit on SoftProjectGoodsBean {
  //初始化属性
  void initGoodsAttrs(CurtainViewModel viewModel) {
    attrList =
        viewModel?.attrsList?.map((e) => ProductSkuAttr.fromJson(e))?.toList();

    styleSkuOption = viewModel?.styleSkuOption;
  }

  //
}
