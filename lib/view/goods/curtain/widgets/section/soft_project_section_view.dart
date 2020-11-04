/*
 * @Description: 软装方案
 * @Author: iamsmiling
 * @Date: 2020-10-09 14:30:06
 * @LastEditTime: 2020-11-04 12:02:20
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/repository/shop/product_bean.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/view/goods/base/title_tip.dart';
import 'package:taojuwu/view/goods/base/trailing_tip.dart';
import 'package:taojuwu/view/goods/curtain/widgets/popup_window/soft_project_popup_window.dart';
import 'package:taojuwu/view/goods/soft_project/soft_project_page.dart';
import 'package:taojuwu/viewmodel/goods/binding/base/base_goods_viewmodel.dart';
import 'package:taojuwu/widgets/zy_photo_view.dart';
import 'package:taojuwu/widgets/zy_plain_button.dart';

class SoftProjectSectionView extends StatelessWidget {
  final List<SoftProjectBean> list;
  const SoftProjectSectionView(this.list, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Visibility(
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
                    children: [TitleTip(title: '软装方案'), TrailingTip()]),
              ),
              AspectRatio(
                aspectRatio: 2.4,
                child: Swiper(
                  itemCount: list.length,
                  viewportFraction: .9,
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
                    return SoftProjectBeanCard(list[i]);
                  },
                ),
              )
            ],
          ),
        ),
        visible: !CommonKit.isNullOrEmpty(list),
      ),
    );
  }
}

class SoftProjectBeanCard extends StatelessWidget {
  final SoftProjectBean bean;
  const SoftProjectBeanCard(this.bean, {Key key}) : super(key: key);

  void jumpTo(BuildContext ctx, SoftProjectBean bean) {
    BaseGoodsViewModel model = ctx.read();
    Navigator.push(ctx, CupertinoPageRoute(builder: (BuildContext context) {
      return SoftProjectPage(model, model.bean?.goodsId, bean?.scenesId);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => jumpTo(context, bean),
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 32),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(4)),
            border: Border.all(width: 1, color: const Color(0xFFE8E8E8)),
            boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(25, 0, 0, 0),
                  blurRadius: 4,
                  spreadRadius: 2),
            ]),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.0,
              child: ZYPhotoView(
                bean.picture,
              ),
            ),
            Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.only(left: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bean?.scenesName ?? '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: const Color(0xFF1B1B1B),
                                  fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 6),
                              child: Text(
                                bean?.name ?? '',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: const Color(0xFF444444)),
                              ),
                            )
                          ],
                        ),
                      ),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '¥${bean.totalPrice}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: const Color(0xFF1B1B1B),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Text(
                                      '¥${bean.marketPrice}',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: const Color(0xFF999999)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            ZYPlainButton(
                              '立即购买',
                              callback: () {
                                return showSoftProjectPopupWindow(
                                    context,
                                    Provider.of(context, listen: false),
                                    bean.scenesId);
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
