/*
 * @Description: 商品属性选择控件
 * @Author: iamsmiling
 * @Date: 2020-09-27 14:14:01
 * @LastEditTime: 2020-09-27 14:59:28
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/viewmodel/goods/binding/base/curtain_goods_binding.dart';
import 'package:taojuwu/viewmodel/goods/binding/curtain/curtain_viewmodel.dart';

import 'attr_options_bar.dart';

class GoodsDetailAttrs extends StatelessWidget {
  final CurtainType curtainType;
  final bool isMeasureOrder;
  const GoodsDetailAttrs(this.curtainType,
      {Key key, this.isMeasureOrder = false})
      : super(
          key: key,
        );

  bool get isWindowGauze => curtainType == CurtainType.WindowGauzeType; // 是否为窗纱
  bool get isWindowRoller => curtainType == CurtainType.WindowRollerType;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: isWindowGauze == true
            ? _buildWindowGauzeOption()
            : isWindowRoller == true
                ? isMeasureOrder
                    ? _buildWindowRollerMeasureOrderOption()
                    : _buildWindowRollerNotMeasureOrderOption()
                : _buildWindowSunBlindOption(),
      ),
    );
  }

  //窗纱的属性
  Widget _buildWindowGauzeOption() {
    return Consumer<CurtainViewModel>(
      builder: (BuildContext context, CurtainViewModel viewModel, _) {
        return Column(
          children: [
            AttrOptionsBar(
              title: '工艺方式',
              trailingText: viewModel?.curCraftAttrBean?.name ?? '',
            ),
            AttrOptionsBar(
              title: '型 材',
              trailingText: viewModel?.curPartAttrBean?.name ?? '',
            ),
            AttrOptionsBar(
              title: '配 饰',
              // isRollUpWindow: goodsProvider?.isWindowGauze,
              trailingText: viewModel?.accText ?? '',
            ),
          ],
        );
      },
    );
  }

  // 非测量单时的卷帘
  Widget _buildWindowRollerNotMeasureOrderOption() {
    return Consumer<CurtainViewModel>(
      builder: (BuildContext context, CurtainViewModel viewModel, _) {
        return Column(
          children: [
            AttrOptionsBar(
              title: '空间',
              trailingText: viewModel?.curRoomAttrBean?.name ?? '',
            ),
            AttrOptionsBar(
              title: '窗型',
              trailingText: '',
            ),
            AttrOptionsBar(
              title: '尺寸',
              // isRollUpWindow: goodsProvider?.isWindowGauze,
              trailingText: viewModel?.sizeText,
              // callback: () {
              //   setSize();
              // },
            ),
            AttrOptionsBar(
              title: '离地距离',
              // isRollUpWindow: goodsProvider?.isWindowGauze,
              trailingText: viewModel?.dyCMStr,
            ),
          ],
        );
      },
    );
  }

  //测量单 卷帘
  Widget _buildWindowRollerMeasureOrderOption() {
    return Consumer<CurtainViewModel>(
      builder: (BuildContext context, CurtainViewModel viewModel, _) {
        return Column(
          children: [
            AttrOptionsBar(
              title: '空间',
              trailingText: viewModel?.measureData?.installRoom ?? '',
              callback: null,
              showNext: false,
            ),
            AttrOptionsBar(
              title: '窗型',
              trailingText: '',
              callback: null,
              showNext: false,
            ),
            AttrOptionsBar(
              title: '尺寸',
              // isRollUpWindow: goodsProvider?.isWindowGauze,
              trailingText: '',
              callback: null,
              showNext: false,
            ),
            AttrOptionsBar(
              title: '离地距离',
              // isRollUpWindow: goodsProvider?.isWindowGauze,
              trailingText: '',
            ),
          ],
        );
      },
    );
  }

  // 普通窗帘
  Widget _buildWindowSunBlindOption() {
    return Consumer<CurtainViewModel>(
      builder: (BuildContext context, CurtainViewModel viewModel, _) {
        return Column(
          children: [
            AttrOptionsBar(
              title: '窗 纱',
              trailingText: viewModel?.curWindowGauzeAttrBean?.name ?? '',
            ),
            AttrOptionsBar(
              title: '工艺方式',
              trailingText: viewModel?.curCraftAttrBean?.name ?? '',
            ),
            AttrOptionsBar(
              title: '型 材',
              trailingText: viewModel?.curPartAttrBean?.name ?? '',
            ),
            AttrOptionsBar(
              title: '里布',
              trailingText: viewModel?.curWindowShadeAttrBean?.name ?? '',
            ),
            AttrOptionsBar(
              title: '幔 头',
              trailingText: viewModel?.curCanopyAttrBean?.name ?? '',
            ),
            AttrOptionsBar(
              title: '配 饰',
              // isRollUpWindow: goodsProvider?.isWindowGauze,
              trailingText: viewModel?.accText ?? '',
            ),
          ],
        );
      },
    );
  }
}
