/*
 * @Description:成品属性编辑卡片
 * @Author: iamsmiling
 * @Date: 2020-10-23 13:42:54
 * @LastEditTime: 2020-10-29 16:46:58
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/config/text_style/taojuwu_text_style.dart';
import 'package:taojuwu/repository/shop/product/base/spec/product_spec_bean.dart';
import 'package:taojuwu/repository/shop/product/end_product/base_end_product_bean.dart';
import 'package:taojuwu/view/product/popup_modal/widgets/end_product_spec_selector.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';

// ignore: must_be_immutable
class EndProductAttrEditableCard<T> extends StatefulWidget {
  final BaseEndProductBean bean;
  const EndProductAttrEditableCard(this.bean, {Key key}) : super(key: key);

  @override
  _EndProductAttrEditableCardState<T> createState() =>
      _EndProductAttrEditableCardState<T>();
}

class _EndProductAttrEditableCardState<T>
    extends State<EndProductAttrEditableCard<T>> {
  BaseEndProductBean get bean => widget.bean;
  List<ProductSpecBean> get list => widget.bean?.specList ?? [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
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
                        '¥600',
                        style: TaojuwuTextStyle.RED_TEXT_STYLE
                            .copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ))
            ],
          ),

          EndProductSpecSelector(bean, setState: setState),
          // EndProductSpecSelector(bean?.specList)
        ],
      ),
    );
  }
}
