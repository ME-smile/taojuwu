/*
 * @Description: 商品属性选择控件
 * @Author: iamsmiling
 * @Date: 2020-09-27 14:14:01
 * @LastEditTime: 2020-10-15 14:21:13
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/view/goods/curtain/widgets/attrs/attr_options_bar.dart';
import 'package:taojuwu/view/goods/curtain/widgets/attrs/measure_data_tip_bar.dart';
import 'package:taojuwu/viewmodel/goods/binding/base/base_goods_viewmodel.dart';
import 'package:taojuwu/viewmodel/goods/binding/base/curtain_goods_binding.dart';
import 'package:taojuwu/viewmodel/goods/binding/curtain/curtain_viewmodel.dart';

class GoodsAttrsSectionView extends StatelessWidget {
  final CurtainType curtainType;
  final bool isMeasureOrder;
  const GoodsAttrsSectionView(this.curtainType,
      {Key key, this.isMeasureOrder = false})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    BaseGoodsViewModel viewModel = context.watch<BaseGoodsViewModel>();
    List skuList = (viewModel as CurtainViewModel)?.skuList ?? [];
    return SliverToBoxAdapter(
      child: Container(
          color: Theme.of(context).primaryColor,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              MeasureDataTipBar(),
              ListBody(
                children: List<Widget>.generate(
                    skuList.length,
                    (index) => AttrOptionsBar(
                          skuList[index],
                          index: index,
                        )),
              ),
            ],
          )),
    );
  }
}
