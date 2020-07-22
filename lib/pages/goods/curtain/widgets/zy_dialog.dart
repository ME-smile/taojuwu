import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:taojuwu/models/shop/sku_attr/accessory_attr.dart';
import 'package:taojuwu/models/shop/sku_attr/canopy_attr.dart';
import 'package:taojuwu/models/shop/sku_attr/craft_attr.dart';
import 'package:taojuwu/models/shop/sku_attr/part_attr.dart';
import 'package:taojuwu/models/shop/sku_attr/window_gauze_attr.dart';
import 'package:taojuwu/models/shop/sku_attr/window_shade_attr.dart';
import 'package:taojuwu/providers/goods_provider.dart';
import 'package:taojuwu/singleton/target_order_goods.dart';
import 'package:taojuwu/utils/ui_kit.dart';

import 'option_view.dart';
import 'sku_attr_picker.dart';

class ZYDialog {
  static void checkAttr(
      BuildContext context, String title, dynamic curOpotion) async {
    await showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          return CheckAttrModal(title, curOpotion);
        });
  }
}

class CheckAttrModal extends StatefulWidget {
  final String title;
  final curOption;
  CheckAttrModal(
    this.title,
    this.curOption, {
    Key key,
  }) : super(key: key);

  @override
  _CheckAttrModalState createState() => _CheckAttrModalState();
}

class _CheckAttrModalState extends State<CheckAttrModal> {
  Map<String, dynamic> dict;
  var tmp;
  String title;
  @override
  void initState() {
    GoodsProvider provider = TargetOrderGoods.instance.goodsProvider;
    tmp = widget.curOption;
    title = widget.title;
    dict = {
      '窗纱选择': {
        'list': provider?.windowGauzeAttr?.data ?? [],
        'tap': (WindowGauzeAttrBean bean) {
          setState(() {
            tmp = bean;
          });
        },
        'confirm': () {
          provider?.curWindowGauzeAttrBean = tmp;
        }
      },
      '工艺方式': {
        'list': provider?.craftAttr?.data ?? [],
        'tap': (CraftAttrBean bean) {
          setState(() {
            tmp = bean;
          });
        },
        'confirm': () {
          provider?.curCraftAttrBean = tmp;
        }
      },
      '型材更换': {
        'list': provider?.partAttr?.data ?? [],
        'tap': (PartAttrBean bean) {
          setState(() {
            tmp = bean;
          });
        },
        'confirm': () {
          provider?.curPartAttrBean = tmp;
        }
      },
      '里布选择': {
        'list': provider?.windowShadeAttr?.data ?? [],
        'tap': (WindowShadeAttrBean bean) {
          setState(() {
            tmp = bean;
          });
        },
        'confirm': () {
          provider?.curWindowShadeAttrBean = tmp;
        }
      },
      '幔头选择': {
        'list': provider?.canopyAttr?.data ?? [],
        'tap': (CanopyAttrBean bean) {
          setState(() {
            tmp = bean;
          });
        },
        'confirm': () {
          provider?.curCanopyAttrBean = tmp;
        }
      },
      '配饰选择': {
        'list': provider?.accessoryAttr?.data ?? [],
        'tap': (AccessoryAttrBean bean) {
          provider?.checkAccessoryAttrBean(bean);
          setState(() {});
        },
        'confirm': () {}
      },
    };

    super.initState();
  }

  bool get isLessOption => dict[title]['list'].length < 4 ?? false;
  @override
  Widget build(BuildContext context) {
    return SkuAttrPicker(
        title: title,
        callback: () {
          dict[title]['confirm']();
          Navigator.of(context).pop();
        },
        child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(
                  horizontal: isLessOption ? UIKit.width(40) : 0),
              alignment: isLessOption ? Alignment.centerLeft : Alignment.center,
              child: Wrap(
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                direction: Axis.horizontal,
                spacing: 8,
                runSpacing: 20,
                children: List.generate(dict[title]['list'].length, (int i) {
                  var item = dict[title]['list'][i];
                  return OptionView(
                    img: item.picture,
                    text: item.name,
                    price: '${item.price ?? ''}',
                    showBorder:
                        title != '配饰选择' ? tmp.id == item.id : item.isChecked,
                    callback: () {
                      dict[title]['tap'](item);
                    },
                  );
                }),
              ),
            )));
  }
}
