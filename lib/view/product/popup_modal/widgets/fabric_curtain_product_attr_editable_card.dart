import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/config/text_style/taojuwu_text_style.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/providers/theme_provider.dart';
import 'package:taojuwu/repository/shop/product/curtain/fabric_curtain_product_bean.dart';
import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';
import 'package:taojuwu/view/edit_product_attr/edit_product_attr_page.dart';
import 'package:taojuwu/view/goods/base/title_tip.dart';
import 'package:taojuwu/view/measure_data/edit_measure_data_page.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';

class FabricCurtainProductAttrEditableCard extends StatefulWidget {
  final FabricCurtainProductBean bean;
  const FabricCurtainProductAttrEditableCard(this.bean, {Key key})
      : super(key: key);

  @override
  _FabricCurtainProductAttrEditableCardState createState() =>
      _FabricCurtainProductAttrEditableCardState();
}

class _FabricCurtainProductAttrEditableCardState
    extends State<FabricCurtainProductAttrEditableCard> {
  FabricCurtainProductBean get bean => widget.bean;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
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
                          widget.bean?.goodsName,
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
                          Navigator.of(context).push(CupertinoPageRoute(
                              builder: (BuildContext context) {
                            return EditMeasureDataPage(bean);
                          })).whenComplete(() {
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
                    })).then((value) {
                      // widget.bean?.attrList = value;
                      setState(() {});
                      // print(value);
                    });
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
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 8),
            itemBuilder: (BuildContext context, int index) {
              ProductSkuAttr item = bean?.attrList[index];
              return Text(
                '${item?.name ?? ''}:${item?.selectedAttrName ?? ''}',
                style: TaojuwuTextStyle.GREY_TEXT_STYLE,
              );
            },
            itemCount: bean?.attrList?.length ?? 0,
          )
        ],
      ),
    );
  }
}
