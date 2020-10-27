/*
 * @Description: 商品详情页
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:55:05
 * @LastEditTime: 2020-10-27 13:16:27
 */
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/application.dart';
import 'package:taojuwu/repository/shop/product/abstract/base_product_bean.dart';
import 'package:taojuwu/repository/shop/product/curtain/fabric_curtain_product_bean.dart';
import 'package:taojuwu/repository/shop/product/design/scene_design_product_bean.dart';
import 'package:taojuwu/repository/shop/product/design/soft_design_product_bean.dart';
import 'package:taojuwu/repository/shop/product/relative_product/relative_product_bean.dart';
import 'package:taojuwu/repository/shop/product_bean.dart';

import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/view/product/widgets/product_detail_footer.dart';
import 'package:taojuwu/view/product/widgets/section/product_attrs_section_view.dart';
import 'package:taojuwu/view/product/widgets/product_detail_header.dart';
import 'package:taojuwu/view/product/widgets/product_detail_profile.dart';
import 'package:taojuwu/view/product/widgets/section/product_html_section_view.dart';
import 'package:taojuwu/view/product/widgets/section/recommend_product_section_view.dart';
import 'package:taojuwu/view/product/widgets/section/relative_product_section_view.dart';
import 'package:taojuwu/view/product/widgets/section/scene_design_product_section_view.dart';
import 'package:taojuwu/view/product/widgets/section/soft_design_product_section_view.dart';
import 'package:taojuwu/viewmodel/product/base/provider/base_product_provider.dart';
import 'package:taojuwu/viewmodel/product/base/provider/single_product/fabric_curtain_product_provider.dart';
import 'package:taojuwu/widgets/loading.dart';

class CurtainProductDetailPage extends StatefulWidget {
  final int goodsId;
  const CurtainProductDetailPage(this.goodsId, {Key key}) : super(key: key);

  @override
  _CurtainProductDetailPageState createState() =>
      _CurtainProductDetailPageState();
}

class _CurtainProductDetailPageState extends State<CurtainProductDetailPage>
    with RouteAware {
  bool isLoading = true;
  FabricCurtainProductBean _productBean;
  List<RelativeProductBean> relativeProductList;
  List<SceneDesignProductBean> sceneDesignProductList;
  List<SoftDesignProductBean> softDesignProductList;
  List<BaseProductBean> recommendProductList;
  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Application.routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    Application.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // fetchData().then((value) {
    //   Provider.of<OrderDetailProvider>(context, listen: false)
    //       .updateModel(model);
    // });
    if (mounted) setState(() {});
    super.didPopNext();
  }

// 发起请求
  Future _fetchData() {
    return OTPService.productDetail(context, params: {'goods_id': 961})
        .then((ProductBeanResp response) {
          _productBean = response?.data?.goodsDetail;
          relativeProductList = response?.data?.relativeProductList;
          sceneDesignProductList = response?.data?.sceneDesignProductList;
          softDesignProductList = response?.data?.softDesignProductList;
          recommendProductList = response?.data?.recommendProductList;
        })
        .catchError((err) => err)
        .whenComplete(() {
          // 初始化商品属性
          _productBean?.fetchAttrsData(() {
            setState(() {});
          });
        })
        .whenComplete(() {
          setState(() {
            isLoading = false;
          });
        })
        .then((_) {
          _productBean?.fetchRoomAttrData();
        });
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
            : ChangeNotifierProvider<BaseProductProvider>(
                create: (context) => FabricCurtainProductProvider(_productBean),
                builder: (BuildContext context, _) {
                  return Scaffold(
                    backgroundColor: const Color(0xFFF8F8F8),
                    body: NestedScrollView(
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[ProductDetailHeader(_productBean)];
                        },
                        body: CustomScrollView(
                          shrinkWrap: true,
                          slivers: [
                            ProductDetailProfile(_productBean),
                            ProductAttrSectionView(_productBean),
                            RelativeProductSectionView(relativeProductList),
                            SliverToBoxAdapter(
                              child: SceneDesignProductSectionView(
                                  sceneDesignProductList),
                            ),
                            SliverToBoxAdapter(
                              child: SoftDesignProductSectionView(
                                  softDesignProductList),
                            ),
                            ProductHtmlDescSectionView(
                                _productBean?.description),
                            SliverToBoxAdapter(
                              child: RecommendedProductSectionView(
                                  recommendProductList),
                            ),
                          ],
                        )),
                    bottomNavigationBar: ProductDeatilFooter(_productBean),
                  );
                },
              ));
    // return ChangeNotifierProvider<SingleProductProvider>(
    //   create: (context)=>(),
    // );
  }
}
