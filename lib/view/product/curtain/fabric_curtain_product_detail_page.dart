/*
 * @Description: 商品详情页
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:55:05
 * @LastEditTime: 2020-11-04 13:56:41
 */
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product/curtain/fabric_curtain_product_bean.dart';
import 'package:taojuwu/view/product/base/base_curtain_product_detail_state.dart';
import 'package:taojuwu/view/product/base/base_product_detail_state.dart';
import 'package:taojuwu/view/product/widgets/product_detail_footer.dart';
import 'package:taojuwu/view/product/widgets/section/fabric_curtain_product_attrs_section_view.dart';
import 'package:taojuwu/view/product/widgets/product_detail_header.dart';
import 'package:taojuwu/view/product/widgets/product_detail_profile.dart';
import 'package:taojuwu/view/product/widgets/section/product_detail_img_section_view.dart';
import 'package:taojuwu/view/product/widgets/section/recommend_product_section_view.dart';
import 'package:taojuwu/view/product/widgets/section/relative_product_section_view.dart';
import 'package:taojuwu/view/product/widgets/section/scene_design_product_section_view.dart';
import 'package:taojuwu/view/product/widgets/section/soft_design_product_section_view.dart';
import 'package:taojuwu/widgets/loading.dart';

class FabricCurtainProductDetailPage extends BaseProductDetailPage {
  final int goodsId;
  FabricCurtainProductDetailPage(this.goodsId, {Key key}) : super(goodsId);

  @override
  _CurtainProductDetailPageState createState() =>
      _CurtainProductDetailPageState();
}

class _CurtainProductDetailPageState
    extends BaseCurtainProductDetailState<FabricCurtainProductDetailPage> {
// 发起请求
  Future sendRequest() {
    return fetchData(context, widget.goodsId).then((_) {
      (productBean as FabricCurtainProductBean)?.fetchAttrsData(() {
        setState(() {
          isLoading = false;
        });
      });
    }).then((_) {
      // 初始化商品属性

      (productBean as FabricCurtainProductBean)
          .fetchRoomAttrData()
          .whenComplete(() {
        copyData();
      });
    }).catchError((err) => err);
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
                backgroundColor: const Color(0xFFF8F8FB),
                body: NestedScrollView(
                    controller: scrollController,
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[ProductDetailHeader(productBean)];
                    },
                    body: CustomScrollView(
                      shrinkWrap: true,
                      slivers: [
                        ProductDetailProfile(productBean),
                        FabricCurtainProductAttrSectionView(productBean),
                        RelativeProductSectionView(relativeProductList),
                        SliverToBoxAdapter(
                          child: SceneDesignProductSectionView(
                              sceneDesignProductList),
                        ),
                        SliverToBoxAdapter(
                          child: SoftDesignProductSectionView(
                            softDesignProductList,
                            goodsId: productBean?.goodsId,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: ProductDetailImgSectionView(
                              productBean?.detailImgList),
                        ),
                        // ProductHtmlDescSectionView(productBean?.description),
                        SliverToBoxAdapter(
                          child: RecommendedProductSectionView(
                              recommendProductList),
                        ),
                      ],
                    )),
                bottomNavigationBar: ProductDeatilFooter(
                  productBean,
                  callback: scrollToTop,
                ),
              ));
    // return ChangeNotifierProvider<SingleProductProvider>(
    //   create: (context)=>(),
    // );
  }
}
