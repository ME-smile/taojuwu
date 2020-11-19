/*
 * @Description: //搭配精选弹窗
 * @Author: iamsmiling
 * @Date: 2020-10-10 13:13:13
 * @LastEditTime: 2020-11-09 11:05:17
 */
import 'package:flutter/cupertino.dart';
import 'package:taojuwu/repository/shop/curtain_product_list_model.dart';
import 'package:taojuwu/view/goods/curtain/widgets/curtain_grid_view.dart';
import 'package:taojuwu/view/goods/curtain/widgets/sku_attr_picker.dart';

/*
 * @Author: iamsmiling
 * @description: 搭配精选弹窗 闯入一个context 和 搭配精选列表
 * @param : 
 * @return {type} 
 * @Date: 2020-10-10 13:32:30
 */
Future showRelateGoodsPopupWindow(
    BuildContext context, List<GoodsItemBean> goodsList) {
  return showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return SkuAttrPicker(
          title: '搭配精选',
          height: 720,
          showButton: false,
          child: GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(5),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 8),
              itemCount: goodsList != null && goodsList.isNotEmpty
                  ? goodsList.length
                  : 0,
              itemBuilder: (BuildContext context, int i) {
                return GridCard(goodsList[i]);
              }),
        );
      });
}
