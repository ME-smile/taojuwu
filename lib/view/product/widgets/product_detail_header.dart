/*
 * @Description: //商品详情顶部appbar
 * @Author: iamsmiling
 * @Date: 2020-10-21 16:10:17
 * @LastEditTime: 2020-11-17 17:51:17
 */
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:taojuwu/repository/shop/product_detail/abstract/single_product_detail_bean.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/user_choose_button.dart';
import 'package:taojuwu/widgets/zy_photo_view.dart';

class ProductDetailHeader extends StatelessWidget {
  final SingleProductDetailBean bean;
  const ProductDetailHeader(this.bean, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      actions: [
        const UserChooseButton(),
      ],
      expandedHeight: 320,
      elevation: .5,
      floating: false,
      pinned: true,
      flexibleSpace:
          bean?.isEndProduct == true ? _buildCarousel() : _buildBanner(),
    );
  }

  FlexibleSpaceBar _buildBanner() {
    return FlexibleSpaceBar(
      background: Container(
          margin: EdgeInsets.only(top: 80),
          child: ZYPhotoView(
            UIKit.getNetworkImgPath(bean?.cover),
            alignment: Alignment.center,
            isAnimated: false,
            width: 300,
            height: 300,
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
            loop: false,
            itemCount: bean?.goodsImgList?.length,
            itemBuilder: (BuildContext context, int index) {
              return ZYPhotoView(
                UIKit.getNetworkImgPath(bean?.goodsImgList[index]),
                width: 300,
                height: 300,
                isAnimated: false,
                alignment: Alignment.center,
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
