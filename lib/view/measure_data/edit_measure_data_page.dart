/*
 * @Description: 测装数据填写页面
 * @Author: iamsmiling
 * @Date: 2020-09-25 12:47:45
 * @LastEditTime: 2020-10-31 17:36:21
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/base_curtain_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/style_selector/curtain_style_selector.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/view/goods/curtain/widgets/attrs/attr_options_bar.dart';
import 'package:taojuwu/view/goods/curtain/widgets/attrs/window_install_mode_option_bar.dart';
import 'package:taojuwu/view/goods/curtain/widgets/attrs/window_open_mode_option_bar.dart';
import 'package:taojuwu/view/goods/curtain/widgets/attrs/window_style_option_bar.dart';
import 'package:taojuwu/view/product/widgets/base/sized_input_box.dart';
import 'package:taojuwu/widgets/zy_assetImage.dart';
import 'package:taojuwu/widgets/zy_submit_button.dart';

class EditMeasureDataPage extends StatefulWidget {
  final BaseCurtainProductDetailBean bean;
  const EditMeasureDataPage(this.bean, {Key key}) : super(key: key);

  @override
  _EditMeasureDataPageState createState() => _EditMeasureDataPageState();
}

class _EditMeasureDataPageState extends State<EditMeasureDataPage> {
  BaseCurtainProductDetailBean get bean => widget.bean;
  CurtainStyleSelector get styleSelector => widget?.bean?.styleSelector;

  ValueNotifier<String> valueNotifier;
  TextEditingController widthController;
  TextEditingController heightController;
  TextEditingController deltaYController;

  String get widthCMStr => widthController.text; //输入框输入的宽度-->以厘米为单位
  String get heightCMStr => heightController.text; // 输入框输入的高度-->以厘米为单位
  String get deltaYCMStr => deltaYController.text; // 输入框输入的离地距离-->以厘米为单位

  double get widthCM => CommonKit.parseDouble(widthCMStr, defaultVal: 0.0);

  double get heightCM => CommonKit.parseDouble(heightCMStr, defaultVal: 0.0);

  double get deltaYCM => CommonKit.parseDouble(deltaYCMStr, defaultVal: 0.0);
  @override
  void initState() {
    super.initState();
    valueNotifier = ValueNotifier<String>(styleSelector?.mainImg);
    widthController = TextEditingController(
        text:
            CommonKit.isNullOrEmpty(bean?.widthCM) ? null : '${bean?.widthCM}');

    heightController = TextEditingController(
        text: CommonKit.isNullOrEmpty(bean?.widthCM)
            ? null
            : '${bean?.heightCM}');

    deltaYController = TextEditingController(
        text: CommonKit.isNullOrEmpty(bean?.widthCM)
            ? null
            : '${bean?.deltaYCM}');
  }

  @override
  void dispose() {
    valueNotifier?.dispose();
    widthController?.dispose();
    heightController?.dispose();
    deltaYController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('测装数据'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                child: ValueListenableBuilder(
                  valueListenable: valueNotifier,
                  builder: (BuildContext context, String mainImg, _) {
                    return ZYAssetImage(
                      mainImg,
                      height: 240,
                      width: 240,
                    );
                  },
                ),
              ),
              Divider(),
              AttrOptionsBar(bean, bean?.roomAttr),
              WindowStyleOptionBar(bean, notifier: valueNotifier),
              ValueListenableBuilder(
                valueListenable: valueNotifier,
                builder: (BuildContext context, String mainImg, _) {
                  return Column(
                    children: [
                      WindowInstallOptionBar(bean),
                      WindowOpenOptionBar(bean),
                    ],
                  );
                },
              ),
              SizedInputBox(
                hintText: '宽(cm):',
                controller: widthController,
              ),
              SizedInputBox(
                hintText: '高(cm):',
                controller: heightController,
              ),
              SizedInputBox(
                hintText: '离地距离:',
                controller: deltaYController,
              )
              // SizeInputBox(viewModel.widthController, hintText: '宽(cm):'),
              // SizeInputBox(viewModel.heightController, hintText: '高(cm):'),
              // SizeInputBox(viewModel.deltaYController, hintText: '离地距离:'),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: ZYSubmitButton('确认', () {
          bean?.setSize(widthCM, heightCM, deltaYCM);
          if (bean?.isValidSize == true) {
            Navigator.of(context).pop();
          }

          // print(viewModel.measureDataStr);
          // viewModel.commitSize();
          // Navigator.of(context).pop();
          // if (!beforeSendData(provider)) return;
          // Navigator.of(context).pop();
          // provider?.hasSetSize = true;
        }),
      ),
    );
  }
}
