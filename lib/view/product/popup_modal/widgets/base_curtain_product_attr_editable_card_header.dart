import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/config/text_style/taojuwu_text_style.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/providers/theme_provider.dart';
import 'package:taojuwu/repository/shop/product/curtain/base_curtain_product_bean.dart';
import 'package:taojuwu/view/edit_product_attr/edit_product_attr_page.dart';
import 'package:taojuwu/view/goods/base/title_tip.dart';
import 'package:taojuwu/view/measure_data/edit_measure_data_page.dart';
import 'package:taojuwu/view/product/dialog/dialog.dart';
import 'package:taojuwu/viewmodel/goods/binding/base/curtain_goods_binding.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';

class BaseCurtainProductAttrEditableCardHeader extends StatelessWidget {
  final BaseCurtainProductBean bean;
  final CurtainType curtainType;

  ///[setState]用于页面刷新 ，状态交由父节点管理
  final StateSetter setState;
  const BaseCurtainProductAttrEditableCardHeader(this.bean, this.curtainType,
      {Key key, this.setState})
      : super(key: key);

  void _refresh() {
    // ignore: unnecessary_statements
    setState != null ? setState(() {}) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                height: 90,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ZYNetImage(
                    imgPath: bean?.cover,
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
                          bean?.goodsName,
                          style: TaojuwuTextStyle.TITLE_TEXT_STYLE,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Text(
                            '默认数据：宽${bean?.widthMStr ?? 0.0}米，高${bean?.heightMStr ?? 0.0}米'),
                      ),
                      GestureDetector(
                        onTap: () {
                          _editMeasureData(context).whenComplete(() {
                            setState(() {});
                          });
                        },
                        child: Row(
                          children: [
                            Text(
                              '修改测装数据',
                              style: TaojuwuTextStyle.YELLOW_TEXT_STYLE
                                  .copyWith(fontSize: 14),
                            ),
                            Icon(
                              ZYIcon.next,
                              color: TaojuwuColors.YELLOW_COLOR,
                              size: 14,
                            )
                          ],
                        ),
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
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TitleTip(
                  title: '属性',
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        CupertinoPageRoute(builder: (BuildContext context) {
                      return EditCurtainProductAttrPage(bean);
                    })).whenComplete(_refresh);
                  },
                  child: Row(
                    children: [
                      Text(
                        '修改属性',
                        style: TaojuwuTextStyle.YELLOW_TEXT_STYLE,
                      ),
                      Icon(
                        ZYIcon.next,
                        color: TaojuwuColors.YELLOW_COLOR,
                        size: 14,
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future _editMeasureData(BuildContext context) {
    if (curtainType == CurtainType.FabricCurtainType) {
      return Navigator.of(context)
          .push(CupertinoPageRoute(builder: (BuildContext context) {
        return EditMeasureDataPage(bean);
      })).whenComplete(_refresh);
    }
    if (curtainType == CurtainType.RollingCurtainType) {
      return setSize(context, bean);
    }
    return Future.value(false);
  }
}
