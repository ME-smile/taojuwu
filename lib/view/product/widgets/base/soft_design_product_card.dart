import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/repository/shop/product/design/soft_design_product_bean.dart';
import 'package:taojuwu/view/product/popup_modal/pop_up_modal.dart';
import 'package:taojuwu/viewmodel/product/base/provider/base_product_provider.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';
import 'package:taojuwu/widgets/zy_plain_button.dart';

class SoftDesignProductCard extends StatelessWidget {
  final SoftDesignProductBean bean;
  const SoftDesignProductCard(this.bean, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () => jumpTo(context, bean),
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
              child: ZYNetImage(
                imgPath: bean.picture,
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
                              bean?.designName ?? '',
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
                                var provider = Provider.of<BaseProductProvider>(
                                    context,
                                    listen: false);
                                return showSoftDesignDetailModalPopup(
                                    context, bean, provider);
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
