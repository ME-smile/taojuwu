/*
 * @Description: 修改卷帘宽高 andoroid 对话框
 * @Author: iamsmiling
 * @Date: 2020-10-28 10:20:44
 * @LastEditTime: 2020-10-31 10:12:38
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/order/order_detail_model.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/base_curtain_product_detail_bean.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/view/product/widgets/base/sized_input_box.dart';
import 'package:taojuwu/widgets/zy_raised_button.dart';
// import 'package:taojuwu/repository/shop/product_detail/curtain/rolling_curtain_product_bean.dart';

class EditRollingCurtainSizeAndroidView extends StatefulWidget {
  final BaseCurtainProductDetailBean bean;
  const EditRollingCurtainSizeAndroidView(this.bean, {Key key})
      : super(key: key);

  @override
  _EditRollingCurtainSizeAndroidViewState createState() =>
      _EditRollingCurtainSizeAndroidViewState();
}

class _EditRollingCurtainSizeAndroidViewState
    extends State<EditRollingCurtainSizeAndroidView> {
  TextEditingController _widthController;
  TextEditingController _heightController;

  OrderGoodsMeasureData get measureData => widget.bean.measureData;

  @override
  void initState() {
    super.initState();
    _widthController = TextEditingController();
    _heightController = TextEditingController();
  }

  @override
  void dispose() {
    _widthController?.dispose();
    _heightController?.dispose();
    super.dispose();
  }

  void _commitSize() {
    // setSize(double widthCM, double heightCM, double deltaYCM) {
    //   measureData.widthCM = widthCM;
    //   measureData.heightCM = heightCM;
    //   measureData.deltaYCM = deltaYCM;
    //   measureData.installRoom = roomAttr.selectedAttrName;
    // }

    measureData?.width = _widthController?.text?.trim();
    measureData?.height = _heightController?.text?.trim();
    measureData?.widthCM = CommonKit.parseDouble(measureData?.width);
    measureData?.heightCM = CommonKit.parseDouble(measureData?.height);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              SizedInputBox(
                hintText: '宽:',
                controller: _widthController,
              ),
              Text('cm')
            ],
          ),
          Row(
            children: [
              SizedInputBox(
                hintText: '高:',
                controller: _heightController,
              ),
              Text('cm')
            ],
          ),
          ZYRaisedButton(
            '确认',
            () {
              _commitSize();
              Navigator.of(context).pop();
            },
            horizontalPadding: 64,
            verticalPadding: 8,
          ),
          GestureDetector(
            child: Text('取消'),
            onTap: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
