/*
 * @Description: 商品详情收藏按钮
 * @Author: iamsmiling
 * @Date: 2020-09-25 12:47:45
 * @LastEditTime: 2020-10-15 15:16:50
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/utils/toast_kit.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/viewmodel/goods/binding/base/base_goods_viewmodel.dart';

class LikeButton extends StatelessWidget {
  const LikeButton({Key key}) : super(key: key);

  void _like(BuildContext context) {
    print('-------******************');
    BaseGoodsViewModel viewModel = Provider.of(context, listen: false);
    int clientId = viewModel.clientId;
    clientId == null ? ToastKit.showInfo('请先选择客户哦') : viewModel.like();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<BaseGoodsViewModel, bool>(
      selector: (BuildContext context, BaseGoodsViewModel viewModel) =>
          viewModel.bean?.isCollect == 1,
      builder: (BuildContext context, bool flag, _) {
        return GestureDetector(
          onTap: () => _like(context),
          child: Container(
              child: Image.asset(
            UIKit.getAssetsImagePath(
              flag ? 'heart_fill.png' : 'heart_blank.png',
            ),
            height: 24,
            width: 24,
          )),
        );
      },
    );
  }
}
