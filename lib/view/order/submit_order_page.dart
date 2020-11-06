/*
 * @Description:提交订单页面 2.0
 * @Author: iamsmiling
 * @Date: 2020-10-28 11:14:01
 * @LastEditTime: 2020-11-06 15:36:12
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/constants/constants.dart';
import 'package:taojuwu/repository/shop/product_detail/abstract/abstract_base_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/abstract/abstract_prodcut_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/abstract/single_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/design/base_design_product_detail_bean.dart';
import 'package:taojuwu/singleton/target_client.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/view/order/widgets/order_remark_card/curtain_order_remark_card.dart';
import 'package:taojuwu/view/order/widgets/order_seller_card.dart';
import 'package:taojuwu/view/order/widgets/product_order_card/end_product_order_card.dart';
import 'package:taojuwu/view/order/widgets/product_order_card/fabric_curtain_product_order_card.dart';
import 'package:taojuwu/view/order/widgets/product_order_card/rolling_curtain_product_order_card.dart';
import 'package:taojuwu/view/order/widgets/submit_order_action_bar.dart';
import 'package:taojuwu/viewmodel/order/order_creator.dart';

import 'widgets/order_buyer_card.dart';

class SubmitOrderPage extends StatefulWidget {
  final AbstractProductDetailBean productDetailBean;
  const SubmitOrderPage(this.productDetailBean, {Key key}) : super(key: key);

  @override
  _SubmitOrderPageState createState() => _SubmitOrderPageState();
}

class _SubmitOrderPageState extends State<SubmitOrderPage> {
  bool get isDesignProduct => widget.productDetailBean?.isDesignProduct;

  bool get isMixinProduct => isDesignProduct
      ? (widget.productDetailBean as BaseDesignProductDetailBean).isMixinProduct
      : false;

  List<SingleProductDetailBean> get goodsList => isDesignProduct
      ? (widget.productDetailBean as BaseDesignProductDetailBean).goodsList
      : [];

  TargetClient get client => widget.productDetailBean?.client;

  AbstractProductDetailBean get bean => widget.productDetailBean;

  OrderCreator orderCreator;
  @override
  void initState() {
    orderCreator = OrderCreator.fromProduct(bean);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('提交订单'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            OrderBuyerCard(orderCreator),
            Divider(height: 1, indent: 12, endIndent: 12),
            Container(
              child: OrderSellerCard(),
              margin: EdgeInsets.only(bottom: 8),
            ),

            // BuyerInfoBar(),

            // SellerInfoBar(),
            // Expanded(child: Text('123456'))
            CommonKit.isNullOrEmpty(goodsList)
                ? _buildProductOrderCard(widget.productDetailBean)
                : ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int i) {
                      SingleProductDetailBean bean = goodsList[i];
                      return _buildProductOrderCard(bean);
                    },
                    separatorBuilder: (BuildContext context, int i) {
                      return Divider(
                        height: 1,
                        endIndent: 16,
                        indent: 16,
                      );
                    },
                    itemCount: goodsList?.length),
            Visibility(
              visible: bean?.productType != ProductType.EndProductType,
              child: CurtainOrderRemarkCard(orderCreator),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                Constants.SERVER_PROMISE,
                style: textTheme.caption,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SubmitOrderActionBar(orderCreator),
    );
  }

  Widget _buildProductOrderCard(AbstractProductDetailBean bean) {
    return bean.productType == ProductType.EndProductType
        ? EndProductOrderCard(bean)
        : bean.productType == ProductType.FabricCurtainProductType
            ? FabricCurtainProductOrderCard(bean)
            : RollingCurtainProductOrderCard(bean);
  }
}
