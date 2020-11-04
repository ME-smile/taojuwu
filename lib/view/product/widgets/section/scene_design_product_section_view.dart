/*
 * @Description: 场景推荐
 * @Author: iamsmiling
 * @Date: 2020-10-23 09:23:42
 * @LastEditTime: 2020-11-04 09:48:14
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:taojuwu/repository/shop/product/design/scene_design_product_bean.dart';

import 'package:taojuwu/utils/extensions/object_kit.dart';
import 'package:taojuwu/view/goods/base/title_tip.dart';
import 'package:taojuwu/view/goods/base/trailing_tip.dart';
import 'package:taojuwu/view/product/scene_design/scene_design_page.dart';
import 'package:taojuwu/view/product/widgets/base/scene_design_product_card.dart';

class SceneDesignProductSectionView extends StatefulWidget {
  final List<SceneDesignProductBean> list;
  const SceneDesignProductSectionView(this.list, {Key key}) : super(key: key);

  @override
  _SceneDesignProductSectionViewState createState() =>
      _SceneDesignProductSectionViewState();
}

class _SceneDesignProductSectionViewState
    extends State<SceneDesignProductSectionView> {
  List<SceneDesignProductBean> get list => widget.list;
  int get currentId => list[swiperController?.index ?? 0]?.id;
  SwiperController swiperController;
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
      visible: !isNullOrEmpty(list),
      child: Container(
        color: Theme.of(context).primaryColor,
        margin: EdgeInsets.only(
          top: 8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TitleTip(title: '场景推荐'),
                    TrailingTip(
                      text: '查看全部',
                      callback: () {
                        // var provider = Provider.of<BaseProductProvider>(context,
                        //     listen: false);
                        // int goodsId = provider?.productBean?.goodsId;
                        Navigator.of(context).push(
                            CupertinoPageRoute(builder: (BuildContext context) {
                          return SceneDesignPage(currentId);
                        }));
                      },
                    )
                  ]),
            ),
            AspectRatio(
              aspectRatio: 1.16,
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Swiper(
                  itemCount: list.length,
                  loop: false,
                  viewportFraction: .96,
                  pagination: new SwiperPagination(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      builder: DotSwiperPaginationBuilder(
                          size: 6.0,
                          activeSize: 6.0,
                          activeColor: Colors.black,
                          color: Colors.black.withOpacity(.3))),
                  itemBuilder: (BuildContext context, int i) {
                    // return SceneProjectCard(list[i]);
                    // return Text('123456789');
                    return SceneDesignProductCard(list[i]);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
