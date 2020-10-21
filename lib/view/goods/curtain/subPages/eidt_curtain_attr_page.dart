/*
 * @Description: 修改属性的页面2.0
 * @Author: iamsmiling
 * @Date: 2020-10-19 14:50:51
 * @LastEditTime: 2020-10-19 15:20:05
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';
import 'package:taojuwu/view/goods/curtain/widgets/option_view.dart';
import 'package:taojuwu/view/goods/curtain/widgets/sku_attr_picker.dart';

//修改属性的页面
class EditCurtainAttrPage extends StatefulWidget {
  final List<ProductSkuAttr> attrList; //属性列表
  EditCurtainAttrPage(this.attrList, {Key key}) : super(key: key);

  @override
  _EditCurtainAttrPageState createState() => _EditCurtainAttrPageState();
}

class _EditCurtainAttrPageState extends State<EditCurtainAttrPage> {
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(widget.attrList);
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: Text('修改属性'),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          children: widget?.attrList
              ?.map((e) => GestureDetector(
                    onTap: () {
                      showCupertinoModalPopup(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              return WillPopScope(
                                  child: SkuAttrPicker(
                                    title: e.title,
                                    callback: () {
                                      Navigator.of(context)
                                          .pop(widget.attrList);
                                      refresh();
                                    },
                                    child: SingleChildScrollView(
                                      physics: BouncingScrollPhysics(),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: GridView.builder(
                                          padding: EdgeInsets.all(0),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 4,
                                            //横轴间距
                                            crossAxisSpacing: 10.0,
                                            childAspectRatio: 0.72,
                                          ),
                                          itemCount: e.data.length,
                                          itemBuilder:
                                              (BuildContext context, int i) {
                                            ProductSkuAttrBean item = e.data[i];
                                            return OptionView(
                                              item,
                                              callback: () {
                                                List<ProductSkuAttrBean> list =
                                                    e?.data ?? [];
                                                if (e.canMultiSelect) {
                                                  ProductSkuAttrBean bean =
                                                      list[i];
                                                  bean.isChecked =
                                                      !bean.isChecked;
                                                } else {
                                                  for (int j = 0;
                                                      j < list.length;
                                                      j++) {
                                                    ProductSkuAttrBean bean =
                                                        list[j];
                                                    bean.isChecked = i == j;
                                                  }
                                                }
                                                setState(() {});
                                              },
                                            );
                                          },
                                          shrinkWrap: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onWillPop: () {
                                    Navigator.of(context).pop();
                                    return Future.value(false);
                                  });
                            });
                          });
                    },
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // mainAxisSize,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              e.name,
                              style: TextStyle(
                                  color: const Color(0xFF333333), fontSize: 14),
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  e.selectedAttrName,
                                  style: TextStyle(
                                      fontSize: 14, color: Color(0xFF1B1B1B)),
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
                    ),
                  ))
              ?.toList(),
        ),
      ),
    );
  }
}
