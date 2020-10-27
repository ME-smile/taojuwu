/*
 * @Description: 场景推荐
 * @Author: iamsmiling
 * @Date: 2020-10-23 09:23:42
 * @LastEditTime: 2020-10-23 13:22:49
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/repository/shop/product/design/scene_design_product_bean.dart';

import 'package:taojuwu/utils/extensions/object_kit.dart';
import 'package:taojuwu/view/goods/base/title_tip.dart';
import 'package:taojuwu/view/goods/base/trailing_tip.dart';
import 'package:taojuwu/view/product/scene_design/scene_design_page.dart';
import 'package:taojuwu/view/product/widgets/base/scene_design_product_card.dart';
import 'package:taojuwu/viewmodel/product/base/provider/base_product_provider.dart';

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
                      text: '查看',
                      callback: () {
                        var provider = Provider.of<BaseProductProvider>(context,
                            listen: false);
                        Navigator.of(context).push(
                            CupertinoPageRoute(builder: (BuildContext context) {
                          return SceneDesignPage(
                              provider, provider?.goodsId, 44);
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
