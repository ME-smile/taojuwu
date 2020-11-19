/*
 * @Description: 商品详情图片
 * @Author: iamsmiling
 * @Date: 2020-11-02 10:31:47
 * @LastEditTime: 2020-11-09 14:08:17
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';

class ProductDetailImgSectionView extends StatelessWidget {
  final List<String> imgList;
  const ProductDetailImgSectionView(this.imgList, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: imgList?.isNotEmpty == true,
      child: Container(
        margin: EdgeInsets.only(top: 8),
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.all(0),
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int i) {
            return ZYNetImage(
              imgPath: imgList[i],
            );
          },
          itemCount: imgList.length,
        ),
      ),
    );
  }
}
