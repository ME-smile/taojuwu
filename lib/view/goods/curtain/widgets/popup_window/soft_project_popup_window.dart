/*
 * @Description: 软装方案立即购买弹窗
 * @Author: iamsmiling
 * @Date: 2020-10-10 16:04:27
 * @LastEditTime: 2020-10-23 15:33:16
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/config/text_style/taojuwu_text_style.dart';
import 'package:taojuwu/repository/shop/product_bean.dart';
import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';
import 'package:taojuwu/view/goods/base/title_tip.dart';
import 'package:taojuwu/view/goods/curtain/subPages/eidt_curtain_attr_page.dart';
import 'package:taojuwu/view/goods/curtain/subPages/pre_measure_data_page.dart';
import 'package:taojuwu/view/goods/curtain/widgets/sku_attr_picker.dart';
import 'package:taojuwu/viewmodel/goods/binding/base/base_goods_viewmodel.dart';
import 'package:taojuwu/viewmodel/goods/binding/curtain/curtain_viewmodel.dart';
import 'package:taojuwu/viewmodel/goods/binding/mixin_goods/mixin_goods_view_model.dart';
import 'package:taojuwu/widgets/zy_action_chip.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';

/*
 * @Author: iamsmiling
 * @description: 传入一个context,goodsModel 
 * @param : int i表示第几套方案
 * @return {type} 
 * @Date: 2020-10-10 17:22:55
 */
Future showSoftProjectPopupWindow(
    BuildContext ctx, BaseGoodsViewModel goodsModel, int id) {
  // SoftProjectBean bean = goodsModel.softProjectList
  //     .firstWhere((element) => element.scenesId == id);
  // Size size = MediaQuery.of(ctx).size;
  // int index = goodsModel.softProjectList.indexOf(element)
  return showCupertinoModalPopup(
      context: ctx,
      builder: (BuildContext context) {
        ThemeData themeData = Theme.of(context);

        return SkuAttrPicker(
          height: 720,
          showButton: false,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            child: ChangeNotifierProvider(
                create: (BuildContext context) =>
                    MixinGoodsViewModel(context, id, goodsModel),
                builder: (BuildContext context, _) {
                  return Consumer<MixinGoodsViewModel>(
                    builder: (BuildContext context,
                        MixinGoodsViewModel viewModel, _) {
                      return Scaffold(
                        backgroundColor: Theme.of(context).primaryColor,
                        body: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                // _buildHeader(viewModel.bean),
                                Divider(
                                  thickness: 8,
                                  color: const Color(0xFFF8F8F8),
                                ),
                                Builder(builder: (BuildContext context) {
                                  List<SoftProjectGoodsBean> list =
                                      viewModel?.goodsList;
                                  print(list.length);
                                  return ListView.separated(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int i) {
                                        SoftProjectGoodsBean item = list[i];
                                        return item.isEndProduct
                                            ? EndProductAttrEditableCard(item)
                                            : CurtainAttrEditableCard(item);
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int i) =>
                                              Divider(
                                                thickness: 8,
                                                color: const Color(0xFFF8F8F8),
                                              ),
                                      itemCount: list?.length ?? 0);
                                })
                              ],
                            ),
                          ),
                        ),
                        bottomNavigationBar: Container(
                          margin: EdgeInsets.all(16),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Builder(
                                  builder: (BuildContext ctx) {
                                    return InkWell(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 8),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1,
                                                color: themeData.accentColor)),
                                        child: Text(
                                          '加入购物车',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                flex: 1,
                              ),
                              Expanded(
                                  child: InkWell(
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8),
                                      decoration: BoxDecoration(
                                          color: themeData.accentColor,
                                          border: Border.all(
                                              color: themeData.accentColor)),
                                      child: Text(
                                        '立即购买',
                                        style: themeData.accentTextTheme.button,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  flex: 1),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
          ),
        );
      });
}

class EndProductAttrEditableCard extends StatelessWidget {
  final SoftProjectGoodsBean bean;
  const EndProductAttrEditableCard(this.bean, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 90,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ZYNetImage(
                      imgPath: bean?.picCoverMid,
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
                            'BML100101负氧离子',
                            style: TaojuwuTextStyle.TITLE_TEXT_STYLE,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Text('已选：白色，1.8米，ai款'),
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
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                ProductBeanSpecListBean item = bean?.specList[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('${item?.specName ?? ''}'),
                    ),
                    Wrap(
                      runSpacing: 8,
                      spacing: 12,
                      children: item?.value
                          ?.map((e) => Container(
                                height: 24,
                                child: AspectRatio(
                                  aspectRatio: 3.0,
                                  child: ZYActionChip(
                                    callback: () {},
                                    bean: ActionBean.fromJson({
                                      'text': e.specValueName,
                                      'is_checked': e.selected
                                    }),
                                  ),
                                ),
                              ))
                          ?.toList(),
                    )
                  ],
                );
              },
              itemCount: bean?.specList?.length ?? 0,
              shrinkWrap: true,
            )
          ],
        );
      }),
    );
  }
}

class CurtainAttrEditableCard extends StatefulWidget {
  final SoftProjectGoodsBean bean;
  const CurtainAttrEditableCard(this.bean, {Key key}) : super(key: key);

  @override
  _CurtainAttrEditableCardState createState() =>
      _CurtainAttrEditableCardState();
}

class _CurtainAttrEditableCardState extends State<CurtainAttrEditableCard> {
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
                    imgPath: widget.bean?.picCoverMid,
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
                            '默认数据：宽${widget.bean?.width ?? 0.0}米，高${widget.bean?.height ?? 0.0}米'),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(CupertinoPageRoute(
                              builder: (BuildContext context) {
                            return PreMeasureDataPage(
                                CurtainViewModel.fromBean(widget.bean));
                          }));
                        },
                        child: Text(
                          '修改测装数据',
                          style: TaojuwuTextStyle.YELLOW_TEXT_STYLE
                              .copyWith(fontSize: 14),
                        ),
                      ),
                      Spacer(),
                      Text(
                        '¥${widget.bean?.displayPrice}',
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
                      return EditCurtainAttrPage(widget.bean.attrList);
                    })).then((value) {
                      widget.bean?.attrList = value;
                      setState(() {});
                      print(value);
                    });
                  },
                  child: Text(
                    '修改属性',
                    style: TaojuwuTextStyle.YELLOW_TEXT_STYLE,
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
              ProductSkuAttr item = widget.bean?.attrList[index];
              return Text(
                '${item?.name ?? ''}:${item?.selectedAttrName ?? ''}',
                style: TaojuwuTextStyle.GREY_TEXT_STYLE,
              );
            },
            itemCount: widget.bean?.attrList?.length ?? 0,
          )
        ],
      ),
    );
  }
}
