/*
 * @Description: 测装数据填写页面
 * @Author: iamsmiling
 * @Date: 2020-09-25 12:47:45
 * @LastEditTime: 2020-10-19 17:34:52
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/view/goods/curtain/widgets/attrs/attr_options_bar.dart';
import 'package:taojuwu/view/goods/curtain/widgets/attrs/size_input_box.dart';
import 'package:taojuwu/view/goods/curtain/widgets/attrs/window_install_mode_option_bar.dart';
import 'package:taojuwu/view/goods/curtain/widgets/attrs/window_open_mode_option_bar.dart';
import 'package:taojuwu/view/goods/curtain/widgets/attrs/window_style_option_bar.dart';
import 'package:taojuwu/viewmodel/goods/binding/curtain/curtain_viewmodel.dart';
import 'package:taojuwu/widgets/zy_assetImage.dart';
import 'package:taojuwu/widgets/zy_submit_button.dart';

class PreMeasureDataPage extends StatelessWidget {
  final CurtainViewModel viewModel;
  const PreMeasureDataPage(this.viewModel, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(viewModel.skuRoom);
    return ChangeNotifierProvider<CurtainViewModel>.value(
      value: viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: Text('测装数据'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: UIKit.width(20), vertical: UIKit.height(20)),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Selector(
                    selector:
                        (BuildContext context, CurtainViewModel viewmodel) =>
                            viewmodel.mainImg,
                    builder: (BuildContext context, String url, _) {
                      return ZYAssetImage(
                        url,
                        height: 240,
                        width: 240,
                      );
                    },
                  ),
                ),
                Divider(),

                // AttrOptionsBar(viewModel.skuRoom),
                WindowStyleOptionBar(),
                WindowInstallOptionBar(),
                WindowOpenOptionBar(),
                SizeInputBox(viewModel.widthController, hintText: '宽(cm):'),
                SizeInputBox(viewModel.heightController, hintText: '高(cm):'),
                SizeInputBox(viewModel.deltaYController, hintText: '离地距离:'),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ZYSubmitButton('确认', () {
            print(viewModel.measureDataStr);
            viewModel.commitSize();
            Navigator.of(context).pop();
            // if (!beforeSendData(provider)) return;
            // Navigator.of(context).pop();
            // provider?.hasSetSize = true;
          }),
        ),
      ),
    );
  }
}
