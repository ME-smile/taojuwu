import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/models/order/order_model.dart';
import 'package:taojuwu/models/shop/cart_list_model.dart';
import 'package:taojuwu/models/zy_response.dart';
import 'package:taojuwu/providers/cart_provider.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/utils/ui_kit.dart';

class CartCardView extends StatefulWidget {
  final CartModel cartModel;
  CartCardView({Key key, this.cartModel}) : super(key: key);

  @override
  _CartCardViewState createState() => _CartCardViewState();
}

class _CartCardViewState extends State<CartCardView> {
  CartModel cartModel;
  String attrsText = '';
  @override
  void initState() {
    super.initState();
    cartModel = widget.cartModel;
    List<OrderProductAttrWrapper> attrs = cartModel.wcAttr;
    attrs.forEach((OrderProductAttrWrapper item) {
      attrsText +=
          '${item.attrName}: ${item.attrs.map((item) => item.name).toList().join('')}  ';
    });
  }

  void delCart() {
    OTPService.delCart(context, params: {
      'cart_id_array': '${['${cartModel?.cartId}' ?? '0']}'
    }).then((ZYResponse response) {
      print(response);
      if (response.valid && response.message.contains('success')) {
        CartProvider provider = Provider.of<CartProvider>(context);
        provider?.removeGoods(cartModel?.cartId);
        Navigator.of(context).pop();
      }
      CommonKit.showToast(response?.message ?? '');
    }).catchError((err) => err);
  }

  void remove() {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('删除'),
            content: Text('您确定要从购物车中删除该商品吗?'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                child: Text('确定'),
                onPressed: () {
                  delCart();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return Consumer<CartProvider>(
        builder: (BuildContext context, CartProvider provider, _) {
      return GestureDetector(
        onLongPress: () {},
        child: Container(
          color: themeData.primaryColor,
          margin: EdgeInsets.only(top: UIKit.height(20)),
          padding: EdgeInsets.symmetric(
              horizontal: UIKit.width(20), vertical: UIKit.height(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Checkbox(
                      value: cartModel?.isChecked,
                      onChanged: (bool isSelected) {
                        provider?.checkGoods(cartModel, isSelected);
                      }),
                  Image.network(
                    UIKit.getNetworkImgPath(
                        cartModel?.pictureInfo?.picCoverSmall),
                    height: UIKit.height(180),
                  ),
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                    height: UIKit.height(180),
                    // width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          cartModel?.goodsName ?? '',
                          style:
                              textTheme.title.copyWith(fontSize: UIKit.sp(28)),
                        ),
                        Expanded(
                          child: Text(
                            attrsText ?? '',
                            softWrap: true,
                            style: textTheme.caption,
                          ),
                        ),
                        Text.rich(TextSpan(
                            text: '￥' + '${cartModel?.price}' ?? '',
                            children: [TextSpan(text: '/米')])),
                      ],
                    ),
                  ))
                ],
              ),
              Text.rich(
                TextSpan(text: '预计总金额', children: [
                  TextSpan(text: '￥' + cartModel?.estimatedPrice ?? '')
                ]),
                textAlign: TextAlign.end,
              ),
            ],
          ),
        ),
      );
    });
  }
}
