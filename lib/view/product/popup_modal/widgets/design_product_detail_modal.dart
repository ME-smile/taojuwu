/*
 * @Description: 软装方案详情
 * @Author: iamsmiling
 * @Date: 2020-10-23 15:34:30
 * @LastEditTime: 2020-11-03 16:49:45
 */
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product_detail/abstract/abstract_base_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/abstract/single_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/base_curtain_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/design/soft_design_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/soft_project_bean.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/singleton/target_client.dart';
import 'package:taojuwu/view/product/mixin/client_select_listener.dart';
import 'package:taojuwu/view/product/mixin/measure_data_holder.dart';
import 'package:taojuwu/view/product/mixin/product_attr_holder.dart';
import 'package:taojuwu/view/product/mixin/style_selector_holder.dart';
import 'package:taojuwu/view/product/popup_modal/widgets/end_product_attr_editable_card.dart';
import 'package:taojuwu/view/product/popup_modal/widgets/rolling_curtain_product_attr_editable_card.dart';
import 'package:taojuwu/view/product/widgets/base/purchase_action_bar.dart';
import 'package:taojuwu/widgets/loading.dart';

import 'fabric_curtain_product_attr_editable_card.dart';
import 'soft_design_modal_header.dart';

class DesignProductDetailModal extends StatefulWidget {
  final int id;
  const DesignProductDetailModal(
    this.id, {
    Key key,
  }) : super(key: key);

  @override
  _DesignProductDetailModalState createState() =>
      _DesignProductDetailModalState();
}

class _DesignProductDetailModalState extends State<DesignProductDetailModal>
    with
        TargetClientHolder,
        StyleSelectorHolder,
        MeasureDataHolder,
        ProductAttrHolder {
  int get id => widget.id;
  bool isLoading = true;
  SoftDesignProductDetailBean bean;
  List<SingleProductDetailBean> goodsList;
  @override
  void initState() {
    _fetchData();
    super.addListener();
    super.initState();
  }

  void _fetchData() {
    OTPService.softDetail(context, params: {'scenes_id': id})
        .then((SoftProjectDetailBeanResp response) {
          if (response?.valid == true) {
            bean = response?.data;
            goodsList = bean?.goodsList;
            bean?.client = client;
          }
        })
        .catchError((err) => err)
        .whenComplete(() {
          setState(() {
            isLoading = false;
          });
        })
        .whenComplete(_copyData);
  }

  _copyData() {
    goodsList?.forEach((e) {
      if (e is BaseCurtainProductDetailBean) {
        e.attrList = ProductAttrHolder.copy();

        e.roomAttr = roomAttr?.copy();

        // ignore: unnecessary_statements
        hasSetSzie ? e.measureData = MeasureDataHolder.copy() : '';
        e.styleSelector = StyleSelectorHolder.copy();
      }
    });
    // if (outterProductDetailBean == null) return;
    // goodsList?.forEach((el) {
    //   if (el is BaseCurtainProductDetailBean &&
    //       outterProductDetailBean?.isFabricCurtainProduct == true) {
    //     FabricCurtainProductDetailBean fabricCurtainProductDetailBean =
    //         outterProductDetailBean as FabricCurtainProductDetailBean;
    //     el.attrList = fabricCurtainProductDetailBean.copyAttrs();

    //     if (fabricCurtainProductDetailBean?.measureData?.hasSetSize == true) {
    //       el.measureData = fabricCurtainProductDetailBean.copyMeasureData();
    //     }

    //     el.roomAttr = ProductSkuAttr.fromJson(
    //         fabricCurtainProductDetailBean?.roomAttr?.toMap());
    //     if (el is FabricCurtainProductDetailBean) {
    //       el.styleSelector = fabricCurtainProductDetailBean?.styleSelector?.copy();
    //     }
    //   }
    // });
  }

  @override
  void dispose() {
    super.relase();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      transitionBuilder: (
        Widget child,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
      child: isLoading
          ? LoadingCircle()
          : Scaffold(
              backgroundColor: Theme.of(context).primaryColor,
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SoftDesignModalHeader(bean),
                    Divider(
                      thickness: 8,
                      color: const Color(0xFFF8F8F8),
                    ),
                    Expanded(
                        child: ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int i) {
                              SingleProductDetailBean item = goodsList[i];
                              return item.productType ==
                                      ProductType.EndProductType
                                  ? EndProductAttrEditableCard(item)
                                  : item.productType ==
                                          ProductType.FabricCurtainProductType
                                      ? FabricCurtainProductAttrEditableCard(
                                          item)
                                      : RollingCurtainProductAttrEditableCard(
                                          item);
                            },
                            separatorBuilder: (BuildContext context, int i) =>
                                Divider(
                                  thickness: 8,
                                  color: const Color(0xFFF8F8F8),
                                ),
                            itemCount: goodsList?.length ?? 0))
                  ],
                ),
              ),
              bottomNavigationBar: Container(
                margin: EdgeInsets.all(16),
                child: PurchaseActionBar(bean),
              ),
            ),
    );
  }

  @override
  set client(TargetClient targetClient) {
    TargetClientHolder.targetClient = targetClient;
    bean?.client = client;
  }
}
