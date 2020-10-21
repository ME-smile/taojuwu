/*
 * @Description: 打开方式选项
 * @Author: iamsmiling
 * @Date: 2020-10-14 14:38:41
 * @LastEditTime: 2020-10-19 17:35:27
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/repository/shop/sku_attr/window_style_sku_option.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/viewmodel/goods/binding/curtain/curtain_viewmodel.dart';
import 'package:taojuwu/widgets/zy_outline_button.dart';
import 'package:taojuwu/widgets/zy_raised_button.dart';

class WindowOpenOptionBar extends StatelessWidget {
  const WindowOpenOptionBar({
    Key key,
  }) : super(key: key);

  void _selectOpenMode(
      BuildContext context, WindowOpenModeOptionBean e, StateSetter setState) {
    context.read<CurtainViewModel>().selectOpenMode(e);
    setState(() {});
  }

  void _selectSubOpenMode(BuildContext context, WindowOpenModeSubOption option,
      WindowOpenModeSubOptionBean optionBean, StateSetter setState) {
    context.read<CurtainViewModel>().selectSubOpenMode(option, optionBean);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //StatefulBuilder
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        //使用selector局部刷新，提高性能
        return Selector(
            builder: (BuildContext context,
                List<WindowOpenModeOptionBean> options, _) {
              return Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          '打开方式',
                          style: TextStyle(
                              color: const Color(0xFF333333), fontSize: 14),
                        ),
                      ),
                      Row(
                        children: options
                            .map((e) => Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: e.isChecked
                                      ? ZYRaisedButton(
                                          e.name,
                                          () => _selectOpenMode(
                                              context, e, setState),
                                          horizontalPadding: 12)
                                      : ZYOutlineButton(
                                          e.name,
                                          () => _selectOpenMode(
                                              context, e, setState),
                                          horizontalPadding: 12),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                  Selector(
                      builder: (BuildContext context,
                          List<WindowOpenModeSubOption> subOptions, _) {
                        return Visibility(
                            child: Column(
                              children: subOptions
                                  ?.map((e) => Container(
                                        child: Row(
                                          children: [
                                            Text(
                                              e?.title ?? '',
                                              style: TextStyle(
                                                  color:
                                                      const Color(0xFF333333),
                                                  fontSize: 14),
                                            ),
                                            Row(
                                              children: e.options
                                                  .map((item) => Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                      child: item.isChecked
                                                          ? ZYRaisedButton(
                                                              item?.name,
                                                              () => _selectSubOpenMode(
                                                                  context,
                                                                  e,
                                                                  item,
                                                                  setState),
                                                              horizontalPadding:
                                                                  12)
                                                          : ZYOutlineButton(
                                                              item?.name,
                                                              () =>
                                                                  _selectSubOpenMode(context, e, item, setState),
                                                              horizontalPadding: 12)))
                                                  ?.toList(),
                                            )
                                          ],
                                        ),
                                      ))
                                  ?.toList(),
                            ),
                            visible: !CommonKit.isNullOrEmpty(subOptions));
                      },
                      selector:
                          (BuildContext context, CurtainViewModel viewModel) =>
                              viewModel.subOpenModeOptions)
                ],
              );
            },
            selector: (BuildContext context, CurtainViewModel viewModel) =>
                viewModel.openOptions);
      },
    );
  }
}
