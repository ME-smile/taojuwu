import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product_detail/design/soft_design_product_detail_bean.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/view/product/popup_modal/pop_up_modal.dart';
import 'package:taojuwu/widgets/zy_photo_view.dart';
import 'package:taojuwu/widgets/zy_plain_button.dart';

class SoftDesignProductCard extends StatelessWidget {
  final SoftDesignProductDetailBean bean;
  const SoftDesignProductCard(this.bean, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDesignProductDetailModal(context, bean?.id),
      child: Container(
        margin: EdgeInsets.only(top: 4, bottom: 32),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(4)),
            border: Border.all(width: 1, color: const Color(0xFFE8E8E8)),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 2),
                  color: Color.fromARGB(16, 0, 0, 0),
                  blurRadius: 3,
                  spreadRadius: 1),
              // BoxShadow(
              //     offset: Offset(0, 2),
              //     color: Color.fromARGB(25, 0, 0, 0),
              //     blurRadius: 4,
              //     spreadRadius: 2)
            ]),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.0,
              child: ZYPhotoView(
                UIKit.getNetworkImgPath(bean.picture),
                tag: bean?.picture,
              ),
            ),
            Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.only(left: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bean?.designName ?? '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 13,
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
                      Expanded(
                        child: Container(
                          alignment: Alignment.bottomCenter,
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
                                    Visibility(
                                      visible: !CommonKit.isNumNullOrZero(
                                          bean.marketPrice),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 8),
                                        child: Text(
                                          '¥${bean.marketPrice}',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: const Color(0xFF999999)),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              ZYPlainButton(
                                '立即购买',
                                callback: () {
                                  return showDesignProductDetailModal(
                                      context, bean?.id);
                                  // return showSoftDesignDetailModalPopup(
                                  //     context, bean, provider);
                                },
                              )
                            ],
                          ),
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
