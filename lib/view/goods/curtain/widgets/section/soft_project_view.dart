/*
 * @Description: 软装方案
 * @Author: iamsmiling
 * @Date: 2020-10-09 14:30:06
 * @LastEditTime: 2020-10-09 17:08:36
 */
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:taojuwu/repository/shop/product_bean.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/view/goods/base/title_tip.dart';
import 'package:taojuwu/view/goods/base/trailing_tip.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';
import 'package:taojuwu/widgets/zy_plain_button.dart';

class SoftProjectView extends StatelessWidget {
  final List<SoftProjectBean> softProjectList;
  const SoftProjectView(this.softProjectList, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Visibility(
        child: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [TitleTip(title: '软装方案'), TrailingTip()]),
              ),
              Container(
                height: 136,
                child: Swiper(
                  itemCount: softProjectList.length,
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
                    return _SoftProjectBeanCard(softProjectList[i]);
                  },
                ),
              )
            ],
          ),
        ),
        visible: !CommonKit.isNullOrEmpty(softProjectList),
      ),
    );
  }
}

class _SoftProjectBeanCard extends StatelessWidget {
  final SoftProjectBean bean;
  const _SoftProjectBeanCard(this.bean, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
          Expanded(
            child: ZYNetImage(
              width: 108,
              height: 108,
              imgPath: bean.picture,
            ),
            flex: 1,
          ),
          Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.only(left: 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bean.scenesName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16,
                                color: const Color(0xFF1B1B1B),
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Text(
                              bean.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 14, color: const Color(0xFF444444)),
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
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
                        ZYPlainButton('立即购买')
                      ],
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
