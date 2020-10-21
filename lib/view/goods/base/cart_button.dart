/*
 * @Description: 购物车图标
 * @Author: iamsmiling
 * @Date: 2020-09-25 12:47:45
 * @LastEditTime: 2020-10-15 14:43:09
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/utils/toast_kit.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/viewmodel/goods/binding/base/base_goods_viewmodel.dart';

class CartButton extends StatelessWidget {
  final int count;

  const CartButton({
    Key key,
    this.count = 0,
  }) : super(key: key);

  ///[context]上下文 页面跳转
  void _jump(BuildContext context) {
    BaseGoodsViewModel viewModel = Provider.of(context, listen: false);
    int clientId = viewModel.clientId;
    clientId == null
        ? ToastKit.showInfo('请先选择客户哦')
        : RouteHandler.goCartPage(context, clientId: clientId);
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _jump(context),
      child: Container(
        width: UIKit.width(60),
        height: UIKit.width(60),
        margin: EdgeInsets.only(bottom: 5),
        alignment: Alignment(0.8, -0.8),
        child: Selector(
          selector: (BuildContext context, BaseGoodsViewModel viewModel) =>
              viewModel.goodsNumInCart,
          builder: (BuildContext context, int count, _) {
            return count == 0
                ? SizedBox.shrink()
                : Container(
                    width: 16,
                    height: 16,
                    alignment: Alignment.center,
                    child: Text(
                      '$count',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: count > 10 ? 10 : 12,
                          fontFamily: 'Roboto'),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                  );
          },
        ),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
          UIKit.getAssetsImagePath(
            'cart_blank.png',
          ),
        ))),
      ),
    );
  }
}
