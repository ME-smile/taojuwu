/*
 * @Description: 商品详情的头部
 * @Author: iamsmiling
 * @Date: 2020-09-27 13:38:18
 * @LastEditTime: 2020-10-12 13:52:30
 */
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:taojuwu/repository/shop/product_bean.dart';
import 'package:taojuwu/widgets/user_choose_button.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';

class GoodsDetailHeader extends StatelessWidget {
  final ProductBean bean;

  const GoodsDetailHeader(
    this.bean, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      actions: <Widget>[UserChooseButton()],
      expandedHeight: 320,
      elevation: 0.5,
      floating: false,
      pinned: true,
      flexibleSpace:
          bean?.isEndProduct == true ? _buildCarousel() : _buildBanner(),
    );
  }

  // 窗帘则使用一张图片作为banner

  FlexibleSpaceBar _buildBanner() {
    return FlexibleSpaceBar(
      background: Container(
          margin: EdgeInsets.only(top: 80),
          child: ZYNetImage(
            imgPath: bean?.picCoverBig,
            width: 300,
            height: 240,
            needAnimation: false,
          )),
    );
  }

  // 成品使用轮播图
  FlexibleSpaceBar _buildCarousel() {
    return FlexibleSpaceBar(
      background: Container(
          // padding: EdgeInsets.symmetric(
          //     horizontal: UIKit.width(50),
          //     vertical: UIKit.height(20)),
          margin: EdgeInsets.only(top: 80),
          child: Swiper(
            key: ValueKey(bean?.goodsId),
            itemCount: bean?.goodsImgList?.length,
            itemBuilder: (BuildContext context, int index) {
              ProductBeanGoodsImageBean item = bean?.goodsImgList[index];
              return ZYNetImage(
                width: 300,
                height: 300,
                imgPath: item?.picCoverBig,
                needAnimation: false,
              );
            },
            pagination: new SwiperPagination(
                margin: EdgeInsets.symmetric(horizontal: 5),
                builder: DotSwiperPaginationBuilder(
                    size: 8.0,
                    activeSize: 8.0,
                    activeColor: Colors.black,
                    color: Colors.black.withOpacity(.3))),
          )),
    );
  }
}
