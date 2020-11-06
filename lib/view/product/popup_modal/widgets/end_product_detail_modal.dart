/*
 * @Description: 成品详情弹窗视图
 * @Author: iamsmiling
 * @Date: 2020-10-28 16:03:14
 * @LastEditTime: 2020-11-04 09:36:58
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/config/text_style/taojuwu_text_style.dart';
import 'package:taojuwu/repository/shop/product_detail/end_product/base_end_product_detail_bean.dart';
import 'package:taojuwu/view/product/popup_modal/widgets/end_product_spec_selector.dart';
import 'package:taojuwu/widgets/step_counter.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';

class EndProductDetailModal extends StatefulWidget {
  final BaseEndProductDetailBean bean;
  EndProductDetailModal(this.bean, {Key key}) : super(key: key);

  @override
  _EndProductDetailModalState createState() => _EndProductDetailModalState();
}

class _EndProductDetailModalState extends State<EndProductDetailModal> {
  BaseEndProductDetailBean get bean => widget.bean;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 90,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ZYNetImage(
                    imgPath: bean?.currentSkuBean?.image,
                    needAnimation: false,
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                margin: EdgeInsets.only(left: 12),
                child: SizedBox(
                  height: 90,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3.0),
                        child: Text(
                          '${bean?.goodsName}',
                          style: TaojuwuTextStyle.TITLE_TEXT_STYLE,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Text(bean?.selectedOptionsName ?? ''),
                      ),
                      Spacer(),
                      Text(
                        '¥${bean?.price}',
                        style: TaojuwuTextStyle.RED_TEXT_STYLE
                            .copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ))
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('数量'),
          ),
          StepCounter(
            model: bean,
          ),
          EndProductSpecSelector(bean, setState: setState),
        ],
      ),
    );
  }
}
