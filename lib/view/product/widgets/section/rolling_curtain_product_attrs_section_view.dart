/*
 * @Description: 卷帘商品属性选择视图
 * @Author: iamsmiling
 * @Date: 2020-10-31 09:15:45
 * @LastEditTime: 2020-10-31 17:42:42
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product/curtain/rolling_curtain_product_bean.dart';
import 'package:taojuwu/view/goods/curtain/widgets/attrs/attr_options_bar.dart';
import 'package:taojuwu/view/goods/curtain/widgets/attrs/rolling_curtain_deltaY_bar.dart';
import 'package:taojuwu/view/goods/curtain/widgets/attrs/rolling_curtain_size_bar.dart';
import 'package:taojuwu/view/goods/curtain/widgets/attrs/window_style_option_bar.dart';

class RollingCurtainProductAttrsSectionView extends StatefulWidget {
  final RollingCurtainProductBean bean;
  RollingCurtainProductAttrsSectionView(this.bean, {Key key}) : super(key: key);

  @override
  _RollingCurtainProductAttrsSectionViewState createState() =>
      _RollingCurtainProductAttrsSectionViewState();
}

class _RollingCurtainProductAttrsSectionViewState
    extends State<RollingCurtainProductAttrsSectionView> {
  RollingCurtainProductBean get bean => widget.bean;
  ValueNotifier<String> valueNotifier;

  @override
  void initState() {
    valueNotifier = ValueNotifier<String>(bean?.styleSelector?.mainImg);
    super.initState();
  }

  @override
  void dispose() {
    valueNotifier?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            AttrOptionsBar(bean, bean?.roomAttr),
            WindowStyleOptionBar(bean, notifier: valueNotifier),
            RollingCurtainSizeBar(bean),
            RollingCurtainDeltaYBar(bean),
          ],
        ),
      ),
    );
  }
}
