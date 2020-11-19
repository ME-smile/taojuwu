/*
 * @Description: 商品属性测装数据提示文字
 * @Author: iamsmiling
 * @Date: 2020-10-22 09:53:45
 * @LastEditTime: 2020-11-19 13:21:49
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/repository/order/order_detail_model.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/base_curtain_product_detail_bean.dart';
import 'package:taojuwu/view/measure_data/confirm_measure_data_page.dart';
import 'package:taojuwu/view/measure_data/edit_measure_data_page.dart';

class MeasureDataTipBar extends StatefulWidget {
  final BaseCurtainProductDetailBean bean;
  MeasureDataTipBar(this.bean, {Key key}) : super(key: key);

  @override
  _MeasureDataTipBarState createState() => _MeasureDataTipBarState();
}

class _MeasureDataTipBarState extends State<MeasureDataTipBar> {
  BaseCurtainProductDetailBean get bean => widget.bean;

  Future jump(BuildContext context) {
    if (bean.isMeasureOrder) {
      return Navigator.of(context).push(CupertinoPageRoute(
          builder: (BuildContext context) => ConfirmMeasureDataPage(bean)));
    }
    return Navigator.push(context,
        CupertinoPageRoute(builder: (BuildContext context) {
      return EditMeasureDataPage(bean);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        GestureDetector(
          onTap: () => jump(context),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: bean?.isMeasureOrder == true
                ? MeasureOrderTip(bean?.measureData)
                : NonMeasureOrderTip(bean),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 8),
          child: Divider(
            height: 1,
            color: const Color(0xFFF1F1F1),
          ),
        )
      ],
    ));
  }
}

// 测量单提示
class MeasureOrderTip extends StatelessWidget {
  final OrderGoodsMeasureData measureData;
  const MeasureOrderTip(this.measureData, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
              child: Text.rich(
            TextSpan(
                text: '*  ',
                style: TextStyle(color: Color(0xFFE02020)),
                children: [
                  TextSpan(
                      text: measureData?.hasConfirmed == true
                          ? '已确认测装数据'
                          : '请确认测装数据',
                      style: textTheme.bodyText2),
                ]),
          )),
          Text(
            measureData?.measureDataStr ?? '',
            textAlign: TextAlign.end,
          ),
          Icon(ZYIcon.next)
        ],
      ),
    );
  }
}

class NonMeasureOrderTip extends StatelessWidget {
  final BaseCurtainProductDetailBean bean;
  const NonMeasureOrderTip(this.bean, {Key key}) : super(key: key);

  OrderGoodsMeasureData get measureData => bean?.measureData;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
              child: Text.rich(
            TextSpan(
                text: '*  ',
                style: TextStyle(color: Color(0xFFE02020)),
                children: [
                  TextSpan(
                      text: measureData?.hasSetSize == true
                          ? '已预填测装数据'
                          : '请预填测装数据',
                      style: textTheme.bodyText2),
                ]),
          )),
          // Spacer(),
          Text(
            measureData?.hasSetSize == true
                ? measureData?.measureDataStr ?? ''
                : '',
            textAlign: TextAlign.end,
          ),
          Icon(
            ZYIcon.next,
            size: 20,
          )
        ],
      ),
    );
  }
}
