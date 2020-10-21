/*
 * @Description: 商品详情页
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:55:05
 * @LastEditTime: 2020-10-21 17:12:03
 */
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/repository/shop/product/curtain/fabric_curtain_product_bean.dart';
import 'package:taojuwu/repository/shop/product_bean.dart';

import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/view/product/widgets/product_detail_header.dart';
import 'package:taojuwu/viewmodel/product/base/provider/single_product/base_curtain_product_provider.dart';
import 'package:taojuwu/viewmodel/product/base/provider/single_product/fabric_curtain_product_provider.dart';
import 'package:taojuwu/viewmodel/product/base/provider/single_product/single_product_provider.dart';
import 'package:taojuwu/widgets/loading.dart';

class CurtainProductDetailPage extends StatefulWidget {
  final int goodsId;
  const CurtainProductDetailPage(this.goodsId, {Key key}) : super(key: key);

  @override
  _CurtainProductDetailPageState createState() =>
      _CurtainProductDetailPageState();
}

class _CurtainProductDetailPageState extends State<CurtainProductDetailPage> {
  bool isLoading = true;
  FabricCurtainProductBean _productBean;
  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  Future _fetchData() =>
      OTPService.productDetail(context, params: {'goods_id': 961})
          .then((ProductBeanResp response) {
        _productBean = response?.data?.goodsDetail;
      }).whenComplete(() {
        setState(() {
          isLoading = false;
        });
      });

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
            : ChangeNotifierProvider<SingleProductProvider>(
                create: (context) => FabricCurtainProductProvider(_productBean),
                builder: (BuildContext context, _) {
                  return Scaffold(
                    backgroundColor: const Color(0xFFF8F8F8),
                    body: NestedScrollView(
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[ProductDetailHeader(_productBean)];
                        },
                        body: Container()),
                  );
                },
              ));
    // return ChangeNotifierProvider<SingleProductProvider>(
    //   create: (context)=>(),
    // );
  }
}
