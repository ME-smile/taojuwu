import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/models/base/goods_attr.dart';
import 'package:taojuwu/pages/goods/curtain/widgets/zy_dialog.dart';
import 'package:taojuwu/providers/goods_provider.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/singleton/target_order_goods.dart';
import 'package:taojuwu/widgets/zy_raised_button.dart';

class EditGoodsAttrPage extends StatefulWidget {
  final int goodsId;
  final int clientId;
  final int cartId;
  final List attrs;
  const EditGoodsAttrPage(
      {Key key, this.attrs, this.goodsId, this.clientId, this.cartId})
      : super(key: key);

  @override
  _EditGoodsAttrPageState createState() => _EditGoodsAttrPageState();
}

class _EditGoodsAttrPageState extends State<EditGoodsAttrPage> {
  int get goodsId => widget.goodsId;
  int get clientId => widget.clientId;
  int get cartId => widget.cartId;
  List<GoodsAttr> get goodsAttrs =>
      widget.attrs?.map((e) => GoodsAttr.fromJson(e))?.toList();

  Map<int, dynamic> get selectedId {
    Map<int, dynamic> dict = {};
    goodsAttrs?.forEach((element) {
      dict[element.type] =
          element?.id is String ? int.parse(element?.id) : element?.id;
    });
    return dict;
  }

  List<Function> get callbacks {
    GoodsProvider provider = TargetOrderGoods.instance.cartGoodsProvider;
    return [
      () {
        ZYDialog.checkAttr(context, '窗纱选择', provider?.curWindowGauzeAttrBean,
            goodsProvider: provider);
      },
      () {
        ZYDialog.checkAttr(context, '型材更换', provider?.curPartAttrBean,
            goodsProvider: provider);
      },
      () {
        ZYDialog.checkAttr(context, '幔头选择', provider?.curCanopyAttrBean,
            goodsProvider: provider);
      },
      () {
        ZYDialog.checkAttr(context, '里布选择', provider?.curWindowShadeAttrBean,
            goodsProvider: provider);
      },
      () {
        ZYDialog.checkAttr(context, '配饰选择', provider?.curAccessoryAttrBeans,
            goodsProvider: provider);
      },
    ];
  }

  List<String> get valueStrList {
    GoodsProvider provider = TargetOrderGoods.instance.cartGoodsProvider;
    return [
      provider?.curWindowGauzeAttrBean?.name,
      provider?.curPartAttrBean?.name,
      provider?.curCanopyAttrBean?.name,
      provider?.curWindowShadeAttrBean?.name,
      provider?.curAccessoryAttrBeansName,
    ];
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() {
    OTPService.fetchCurtainAttrData(context, params: {
      'goods_id': goodsId,
      'client_uid': clientId,
    }).then((data) {
      if (mounted) {
        TargetOrderGoods.instance.cartGoodsProvider
            .initDataFromGoodsAttr(data, selectedId);
      }
    }).catchError((err) => err);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('修改属性'),
        centerTitle: true,
        bottom: PreferredSize(
            child: Container(
              height: 8,
              color: const Color(0xFFF7F7F7),
            ),
            preferredSize: Size.fromHeight(8)),
      ),
      body: ChangeNotifierProvider<GoodsProvider>(
        create: (BuildContext context) {
          GoodsProvider goodsProvider = GoodsProvider();
          TargetOrderGoods.instance.setCartGoodsProvider(goodsProvider);
          return goodsProvider;
        },
        child: Consumer<GoodsProvider>(
          builder: (BuildContext context, GoodsProvider provider, _) {
            return Container(
                color: themeData.primaryColor,
                height: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListView.separated(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: goodsAttrs?.length ?? 0,
                      itemBuilder: (BuildContext context, int i) {
                        GoodsAttr bean = goodsAttrs[i];
                        return InkWell(
                          onTap: callbacks[i],
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(bean?.name ?? ''),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Text(valueStrList[i] ?? ''),
                                      Icon(
                                        ZYIcon.next,
                                        size: 16,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int i) {
                        return Divider(
                          height: 1,
                        );
                      },
                    ),
                    Divider(
                      height: 1,
                    )
                  ],
                ));
          },
        ),
      ),
      bottomNavigationBar: Container(
        color: themeData.primaryColor,
        padding: EdgeInsets.symmetric(horizontal: 46),
        child: ZYRaisedButton('确定', () {
          TargetOrderGoods.instance.cartGoodsProvider.modifyCartAttr(
            context,
            params: {
              'cart_id': cartId,
            },
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    TargetOrderGoods.instance.cartGoodsProvider?.release();
    super.dispose();
  }
}
