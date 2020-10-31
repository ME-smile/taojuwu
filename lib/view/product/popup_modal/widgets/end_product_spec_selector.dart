/*
 * @Description: 成品规格选择
 * @Author: iamsmiling
 * @Date: 2020-10-28 16:15:09
 * @LastEditTime: 2020-10-28 16:30:51
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product/base/spec/product_spec_bean.dart';
import 'package:taojuwu/repository/shop/product/end_product/base_end_product_bean.dart';
import 'package:taojuwu/widgets/zy_action_chip.dart';

class EndProductSpecSelector extends StatelessWidget {
  final BaseEndProductBean bean;
  final StateSetter setState;
  const EndProductSpecSelector(this.bean, {Key key, this.setState})
      : super(key: key);

  List<ProductSpecBean> get list => bean?.specList;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(0),
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          ProductSpecBean item = list[index];
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('${item?.name ?? ''}'),
              ),
              Wrap(
                runSpacing: 8,
                spacing: 12,
                children: item?.options
                    ?.map((e) => Container(
                          height: 24,
                          child: AspectRatio(
                            aspectRatio: 3.0,
                            child: ZYActionChip(
                              callback: () {
                                setState(() {
                                  bean?.selectSpecOption(list[index], e);
                                });
                              },
                              bean: ActionBean.fromJson({
                                'text': e?.name,
                                'is_checked': e?.isSelected
                              }),
                            ),
                          ),
                        ))
                    ?.toList(),
              )
            ],
          );
        },
        itemCount: list?.length ?? 0,
        shrinkWrap: true,
      ),
    );
  }
}
