/*
 * @Description: 选择属性
 * @Author: iamsmiling
 * @Date: 2020-10-22 10:19:51
 * @LastEditTime: 2020-10-22 10:34:39
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';

class AttrOptionBar extends StatefulWidget {
  final ProductSkuAttr attr;
  AttrOptionBar(this.attr, {Key key}) : super(key: key);

  @override
  _AttrOptionBarState createState() => _AttrOptionBarState();
}

class _AttrOptionBarState extends State<AttrOptionBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // mainAxisSize,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Text(
              widget.attr.name,
              style: TextStyle(color: const Color(0xFF333333), fontSize: 14),
            ),
            flex: 1,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  widget.attr.selectedAttrName,
                  style: TextStyle(fontSize: 14, color: Color(0xFF1B1B1B)),
                ),
                Icon(
                  ZYIcon.next,
                  size: 20,
                )
              ],
            ),
            flex: 4,
          )
        ],
      ),
    );
  }
}
