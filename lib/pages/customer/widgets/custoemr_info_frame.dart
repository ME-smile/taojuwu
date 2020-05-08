import 'package:flutter/material.dart';
import 'package:taojuwu/models/user/customer_detail_model.dart';
import 'package:taojuwu/utils/ui_kit.dart';

class CustomerInfoFrame extends StatelessWidget {
  final CustomerDetailModel model;
  const CustomerInfoFrame({Key key, this.model}) : super(key: key);


  Widget _infoBar(
    BuildContext context,
    String title,
    String text,
  ) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: UIKit.width(20), vertical: UIKit.height(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[Text(title), Text(text,style: textTheme.caption,)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Container(
      color: themeData.primaryColor,
      child: Column(
        children: <Widget>[
          _infoBar(context, '来源', '门店游客'),
          Divider(),
          _infoBar(context, '手机', model?.clientMobile ?? ''),
          Divider(),
          _infoBar(context, '微信', model?.clientWx ?? ''),
        ],
      ),
    );
  }
}
