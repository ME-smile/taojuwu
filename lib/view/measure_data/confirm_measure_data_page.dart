/*
 * @Description: 确认测装数据的页面
 * @Author: iamsmiling
 * @Date: 2020-11-19 09:38:32
 * @LastEditTime: 2020-11-20 10:18:03
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/repository/order/order_detail_model.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/base_curtain_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/fabric_curtain_product_detail_bean.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/view/measure_data/dialog.dart';
import 'package:taojuwu/view/measure_data/edit_open_mode_page.dart';
import 'package:taojuwu/widgets/zy_photo_view.dart';
import 'package:taojuwu/widgets/zy_submit_button.dart';

class ConfirmMeasureDataPage extends StatefulWidget {
  final BaseCurtainProductDetailBean bean;
  ConfirmMeasureDataPage(this.bean, {Key key}) : super(key: key);

  @override
  _ConfirmMeasureDataPageState createState() => _ConfirmMeasureDataPageState();
}

class _ConfirmMeasureDataPageState extends State<ConfirmMeasureDataPage> {
  FabricCurtainProductDetailBean get bean => widget.bean;
  OrderGoodsMeasureData get measureData => bean.measureData;

  Widget buildText(String text, {double width}) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(vertical: UIKit.height(20)),
      child: Text(text ?? ''),
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('测装数据'),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: UIKit.width(40), vertical: UIKit.height(20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  buildText('空间:${measureData?.installRoom ?? ''}',
                      width: (w - UIKit.width(40) * 2) / 2),
                  buildText('窗户类型:${measureData?.windowMeasureType ?? ''}'),
                ],
              ),
              Container(
                // alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(vertical: UIKit.height(10)),
                child: buildText('窗型:${measureData?.windowType ?? ''}'),
              ),
              Divider(
                indent: UIKit.width(20),
                endIndent: UIKit.width(20),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    buildText('安装方式:${measureData?.installType ?? ''}',
                        width: (w - UIKit.width(40) * 2) / 2),
                    buildText('型材类型:${measureData?.partsName ?? ''}'),
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    buildText(
                        '安装面材质:${measureData?.installFaceMaterials ?? ''}',
                        width: (w - UIKit.width(40) * 2) / 2),
                    buildText(
                        '石膏线:${measureData?.plasterLine == 0 ? '没有' : '有'}'),
                  ],
                ),
              ),
              Divider(
                indent: UIKit.width(20),
                endIndent: UIKit.width(20),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    buildText(
                        '宽（cm）:${measureData?.width ?? ''} ${measureData?.widthExplain ?? ''}'),
                    buildText(
                        '高（cm）:${measureData?.height ?? ''} ${measureData?.heightExplain ?? ''}'),
                  ],
                ),
              ),
              Divider(
                indent: UIKit.width(20),
                endIndent: UIKit.width(20),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    buildText('框内安装面宽度:${measureData?.frameWidth ?? '0'}cm'),
                    buildText(
                        '窗帘盒宽*高（cm）:${measureData?.curtainBoxSize ?? '0'}'),
                    buildText('顶/石膏线下到窗户上沿:${measureData?.topHeight ?? '0'}cm'),
                  ],
                ),
              ),
              Divider(
                indent: UIKit.width(20),
                endIndent: UIKit.width(20),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        buildText(
                            '离地距离:${measureData?.newVerticalGroundHeight ?? '0'}cm'),
                        Text(measureData?.hasModifiedDeltaY == true
                            ? '  原(${measureData?.verticalGroundHeight ?? 0}cm)'
                            : ''),
                        InkWell(
                          child: Icon(
                            ZYIcon.edit,
                            size: 14,
                          ),
                          onTap: () {
                            modifyDeltaY(context, measureData).whenComplete(() {
                              setState(() {});
                            });
                            // setDy(goodsProvider);
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        buildText(
                            '打开方式:${measureData?.newOpenType ?? '暂未选择打开方式'}'),
                        Visibility(
                          child: Text('(原${measureData?.openType ?? ''})'),
                          visible: measureData.hasModifiedOpenMode &&
                              !CommonKit.isNullOrEmpty(measureData.openType),
                        ),
                        // Text(measureData.hasModifiedOpenMode == true
                        //     ? ' '
                        //     : ''),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (BuildContext context) {
                              return EditOpenModePage(bean);
                            })).whenComplete(() {
                              setState(() {});
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Icon(
                              ZYIcon.edit,
                              size: 14,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                indent: UIKit.width(20),
                endIndent: UIKit.width(20),
              ),
              Container(
                // alignment: Alignment.centerLeft,
                child: buildText('测量备注记录:${measureData?.remark ?? ''}'),
              ),
              Divider(
                indent: UIKit.width(20),
                endIndent: UIKit.width(20),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('图片:'),
                    Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                        child: ZYPhotoView(
                          UIKit.getNetworkImgPath(measureData?.picture ?? ''),
                          width: UIKit.width(200),
                          tag: CommonKit.getRandomStr(),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ZYSubmitButton('确认', () {
        measureData?.hasConfirmed = true;
        Navigator.of(context).pop();
      }),
    );
  }
}
