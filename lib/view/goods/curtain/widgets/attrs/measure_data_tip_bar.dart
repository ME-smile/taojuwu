/*
 * @Description: 属性选择上方的提示文字
 * @Author: iamsmiling
 * @Date: 2020-09-29 13:07:04
 * @LastEditTime: 2020-11-18 14:41:35
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/view/goods/curtain/subPages/pre_measure_data_page.dart';
import 'package:taojuwu/viewmodel/goods/binding/base/base_goods_viewmodel.dart';
import 'package:taojuwu/viewmodel/goods/binding/curtain/curtain_viewmodel.dart';

class MeasureDataTipBar extends StatelessWidget {
  const MeasureDataTipBar({Key key}) : super(key: key);

  void _jump(BuildContext context, CurtainViewModel viewModel) {
    Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) {
      return PreMeasureDataPage(viewModel);
    })).then((value) {
      viewModel?.refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BaseGoodsViewModel>(
        builder: (BuildContext context, BaseGoodsViewModel viewModel, _) {
      return GestureDetector(
        onTap: () {
          CurtainViewModel viewModel = Provider.of(context);
          _jump(context, viewModel);
        },
        child: Container(
            margin: EdgeInsets.only(top: 16),
            child: Column(
              children: [
                (viewModel as CurtainViewModel)?.isMeasureOrder == true
                    ? _buildMeasureOrderTip(context)
                    : _buildNotMeasureOrderTip(context, viewModel),
                Divider()
              ],
            )),
      );
    });
  }

  //测量单时的提示文字
  Widget _buildMeasureOrderTip(
    BuildContext context,
  ) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return GestureDetector(
        onTap: () {
          CurtainViewModel viewModel = Provider.of(context);
          _jump(context, viewModel);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Selector<CurtainViewModel, bool>(
              selector: (BuildContext context, CurtainViewModel viewModel) =>
                  viewModel.hasConfirmSize,
              builder: (BuildContext context, bool flag, _) {
                return Text.rich(
                  TextSpan(
                      text: '*  ',
                      style: TextStyle(color: Color(0xFFE02020)),
                      children: [
                        TextSpan(
                            text: flag ? '已确认测装数据' : '请确认测装数据',
                            style: textTheme.bodyText2),
                      ]),
                );
              },
            ),
            // Spacer(),
            Selector<CurtainViewModel, String>(
              selector: (BuildContext context, CurtainViewModel viewModel) =>
                  viewModel.measureDataStr,
              builder: (BuildContext context, String text, _) {
                return Text(
                  text ?? '',
                  textAlign: TextAlign.end,
                );
              },
            ),
            Icon(ZYIcon.next)
          ],
        ));
  }

  // 非测量单时的提示文字
  Widget _buildNotMeasureOrderTip(
      BuildContext context, CurtainViewModel curtainViewModel) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return GestureDetector(
      onTap: () {
        _jump(context, curtainViewModel);
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text.rich(
              TextSpan(
                  text: '*  ',
                  style: TextStyle(color: Color(0xFFE02020)),
                  children: [
                    TextSpan(
                        text: curtainViewModel?.hasSetSize == true
                            ? '已预填测装数据'
                            : '请预填测装数据',
                        style: textTheme.bodyText2),
                  ]),
            ),
            Spacer(),
            Text(
              curtainViewModel?.hasSetSize == true
                  ? curtainViewModel?.measureDataStr ?? ''
                  : '',
              textAlign: TextAlign.end,
            ),
            Icon(
              ZYIcon.next,
              size: 20,
            )
          ],
        ),
      ),
    );
  }
}
