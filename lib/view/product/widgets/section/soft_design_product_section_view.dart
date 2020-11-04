/*
 * @Description: 软装方案
 * @Author: iamsmiling
 * @Date: 2020-10-23 09:50:07
 * @LastEditTime: 2020-11-04 09:47:48
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:taojuwu/repository/shop/product/design/soft_design_product_bean.dart';
import 'package:taojuwu/view/goods/base/title_tip.dart';
import 'package:taojuwu/utils/extensions/object_kit.dart';
import 'package:taojuwu/view/goods/base/trailing_tip.dart';
import 'package:taojuwu/view/product/soft_design/soft_design_page.dart';
import 'package:taojuwu/view/product/widgets/base/soft_design_product_card.dart';

class SoftDesignProductSectionView extends StatefulWidget {
  final int goodsId;
  final List<SoftDesignProductBean> list;
  const SoftDesignProductSectionView(this.list, {Key key, this.goodsId})
      : super(key: key);

  @override
  _SoftDesignProductSectionViewState createState() =>
      _SoftDesignProductSectionViewState();
}

class _SoftDesignProductSectionViewState
    extends State<SoftDesignProductSectionView> {
  SwiperController swiperController;

  int get currentSceneId => widget.list[swiperController?.index ?? 0]?.id;
  @override
  void initState() {
    swiperController = SwiperController();
    super.initState();
  }

  @override
  void dispose() {
    swiperController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: Container(
        color: Theme.of(context).primaryColor,
        margin: EdgeInsets.only(top: 8),
        padding: EdgeInsets.only(bottom: 16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TitleTip(title: '软装方案'),
                    TrailingTip(
                      text: '查看全部',
                      callback: () {
                        Navigator.of(context).push(
                            CupertinoPageRoute(builder: (BuildContext conext) {
                          return SoftDesignPage(widget.goodsId);
                        }));
                      },
                    )
                  ]),
            ),
            AspectRatio(
              aspectRatio: 2.4,
              child: Swiper(
                itemCount: widget.list.length,
                viewportFraction: .9,
                loop: false,
                controller: swiperController,
                pagination: new SwiperPagination(
                    margin: EdgeInsets.all(0),
                    builder: DotSwiperPaginationBuilder(
                        size: 6.0,
                        activeSize: 6.0,
                        activeColor: Colors.black,
                        color: Colors.black.withOpacity(.3))),
                itemBuilder: (BuildContext context, int i) {
                  return SoftDesignProductCard(widget.list[i]);
                },
              ),
            )
          ],
        ),
      ),
      visible: !isNullOrEmpty(widget.list),
    );
  }
}
