/*
 * @Description: 属性选择上方的提示文字
 * @Author: iamsmiling
 * @Date: 2020-09-29 13:07:04
 * @LastEditTime: 2020-09-29 17:16:14
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/view/goods/curtain/subPages/pre_measure_data_page.dart';
import 'package:taojuwu/viewmodel/goods/binding/curtain/curtain_viewmodel.dart';

class MeasureDataTipBar extends StatelessWidget {
  const MeasureDataTipBar({Key key}) : super(key: key);

  void _jump(BuildContext context, CurtainViewModel viewModel) {
    Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) {
      return PreMeasureDataPage(viewModel);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CurtainViewModel>(
        builder: (BuildContext context, CurtainViewModel viewModel, _) {
      return viewModel?.isMeasureOrder == true
          ? _buildMeasureOrderTip(context, viewModel)
          : _buildNotMeasureOrderTip(context, viewModel);
    });
  }

  //测量单时的提示文字
  Widget _buildMeasureOrderTip(
      BuildContext context, CurtainViewModel curtainViewModel) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return GestureDetector(
        onTap: () {
          _jump(context, curtainViewModel);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text.rich(
              TextSpan(
                  text: '*  ',
                  style: TextStyle(color: Color(0xFFE02020)),
                  children: [
                    TextSpan(
                        text: curtainViewModel.hasConfirmSize
                            ? '已确认测装数据'
                            : '请确认测装数据',
                        style: textTheme.bodyText2),
                  ]),
            ),
            Spacer(),
            Text(
              curtainViewModel.hasConfirmSize == true
                  ? curtainViewModel?.measureDataStr ?? ''
                  : '',
              textAlign: TextAlign.end,
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
          Icon(ZYIcon.next)
        ],
      ),
    );
  }
}
