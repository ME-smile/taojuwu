import 'package:flutter/material.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/widgets/zy_outline_button.dart';

class PreviewDeliveryInfoButton extends StatelessWidget {
  final String text;
  final Function callback;
  final int orderId;
  const PreviewDeliveryInfoButton(
      {Key key, this.text: '查看物流', this.orderId, this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZYOutlineButton(text, () {
      if (callback != null) callback();
      RouteHandler.goLogisticsPage(context, orderId);
    });
  }
}
