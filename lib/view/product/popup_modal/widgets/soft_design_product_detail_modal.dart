/*
 * @Description: 软装方案详情
 * @Author: iamsmiling
 * @Date: 2020-10-23 15:34:30
 * @LastEditTime: 2020-10-27 17:38:46
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product/abstract/base_product_bean.dart';
import 'package:taojuwu/repository/shop/product/abstract/single_product_bean.dart';
import 'package:taojuwu/repository/shop/product/curtain/fabric_curtain_product_bean.dart';
import 'package:taojuwu/repository/shop/product/design/soft_design_product_bean.dart';
import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';
import 'package:taojuwu/repository/shop/soft_project_bean.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/view/product/popup_modal/widgets/end_product_attr_editable_card.dart';
import 'package:taojuwu/view/product/widgets/base/purchase_action_bar.dart';
import 'package:taojuwu/viewmodel/product/base/provider/base_product_provider.dart';

import 'fabric_curtain_product_attr_editable_card.dart';
import 'soft_design_modal_header.dart';

class SoftDesignProductDetailModal extends StatefulWidget {
  final BaseProductProvider provider;
  const SoftDesignProductDetailModal(this.provider, {Key key})
      : super(key: key);

  @override
  _SoftDesignProductDetailModalState createState() =>
      _SoftDesignProductDetailModalState();
}

class _SoftDesignProductDetailModalState
    extends State<SoftDesignProductDetailModal> {
  BaseProductProvider get provider => widget.provider;
  //入口进来的商品
  BaseProductBean get outterProductBean => provider?.productBean;

  bool isLoading = true;
  SoftDesignProductBean bean;
  List<SingleProductBean> goodsList;
  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  void _fetchData() {
    OTPService.softDetail(context, params: {'scenes_id': 44})
        .then((SoftProjectDetailBeanResp response) {
          if (response?.valid == true) {
            bean = response?.data;
            goodsList = bean?.goodsList;
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
    goodsList?.forEach((el) {
      if (el is FabricCurtainProductBean &&
          outterProductBean?.isFabricCurtainProduct == true) {
        FabricCurtainProductBean fabricCurtainProductBean =
            outterProductBean as FabricCurtainProductBean;
        el.attrList = fabricCurtainProductBean.copyAttrs();

        if (fabricCurtainProductBean?.measureData?.hasSetSize == true) {
          el.measureData = fabricCurtainProductBean.copyMeasureData();
        }

        // el.styleSelector = CurtainStyleSelector.fromJson(
        //     fabricCurtainProductBean?.styleSelector?.toJson());
        el.styleSelector = fabricCurtainProductBean?.styleSelector?.copy();

        el.roomAttr = ProductSkuAttr.fromJson(
            fabricCurtainProductBean?.roomAttr?.toMap());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      SingleProductBean item = goodsList[i];
                      return item?.isEndProduct == true
                          ? EndProductAttrEditableCard(item)
                          : FabricCurtainProductAttrEditableCard(item);
                    },
                    separatorBuilder: (BuildContext context, int i) => Divider(
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
    );
  }
}
