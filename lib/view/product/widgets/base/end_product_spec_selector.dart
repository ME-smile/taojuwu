/*
 * @Description: 成品属性选择
 * @Author: iamsmiling
 * @Date: 2020-10-23 14:10:57
 * @LastEditTime: 2020-10-27 13:31:18
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product/base/spec/product_spec_bean.dart';
import 'package:taojuwu/widgets/zy_action_chip.dart';

class EndProductSpecSelector extends StatefulWidget {
  final List<ProductSpecBean> list;
  const EndProductSpecSelector(this.list, {Key key}) : super(key: key);

  @override
  _EndProductSpecSelectorState createState() => _EndProductSpecSelectorState();
}

class _EndProductSpecSelectorState extends State<EndProductSpecSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          ProductSpecBean item = widget.list[index];
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
                              callback: () {},
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
        itemCount: widget.list?.length ?? 0,
        shrinkWrap: true,
      ),
    );
  }
}
