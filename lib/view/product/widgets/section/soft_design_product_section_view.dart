/*
 * @Description: 软装方案
 * @Author: iamsmiling
 * @Date: 2020-10-23 09:50:07
 * @LastEditTime: 2020-10-23 10:59:43
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/repository/shop/product/design/soft_design_product_bean.dart';
import 'package:taojuwu/view/goods/base/title_tip.dart';
import 'package:taojuwu/utils/extensions/object_kit.dart';
import 'package:taojuwu/view/goods/base/trailing_tip.dart';
import 'package:taojuwu/view/product/soft_design/soft_design_page.dart';
import 'package:taojuwu/view/product/widgets/base/soft_design_product_card.dart';
import 'package:taojuwu/viewmodel/product/base/provider/base_product_provider.dart';

class SoftDesignProductSectionView extends StatefulWidget {
  final List<SoftDesignProductBean> list;
  const SoftDesignProductSectionView(this.list, {Key key}) : super(key: key);

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
        padding: EdgeInsets.only(left: 16, bottom: 16, right: 16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TitleTip(title: '软装方案'),
                    TrailingTip(
                      text: '全部',
                      callback: () {
                        var provider = Provider.of<BaseProductProvider>(context,
                            listen: false);
                        Navigator.of(context).push(
                            CupertinoPageRoute(builder: (BuildContext conext) {
                          return SoftDesignPage(
                              provider, provider?.goodsId, currentSceneId);
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
                controller: swiperController,
                pagination: new SwiperPagination(
                    margin: EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
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
