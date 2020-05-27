import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/models/order/order_detail_model.dart';
import 'package:taojuwu/providers/goods_provider.dart';
import 'package:taojuwu/providers/order_provider.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/loading.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';
import 'package:taojuwu/widgets/zy_submit_button.dart';

class MeasureDataPreviewPage extends StatefulWidget {
  MeasureDataPreviewPage({Key key}) : super(key: key);

  @override
  _MeasureDataPreviewPageState createState() => _MeasureDataPreviewPageState();
}

class _MeasureDataPreviewPageState extends State<MeasureDataPreviewPage> {
  OrderGoodsMeasure measureData;
  @override
  void initState() {
    super.initState();
    OrderProvider orderProvider =
        Provider.of<OrderProvider>(context, listen: false);
    GoodsProvider goodsProvider =
        Provider.of<GoodsProvider>(context, listen: false);
    OTPService.measureData(context,
            params: {'order_goods_id': orderProvider?.orderGoodsId})
        .then((OrderGoodsMeasure data) {
      if (goodsProvider?.dy == '0.0') {
        goodsProvider?.dy = data?.verticalGroundHeight;
      }
      goodsProvider?.partName = data?.partsName;
      setState(() {
        measureData = data;
        isLoading = false;
        // goodsProvider?.width = measureData?.width;
        // goodsProvider?.height = measureData?.height;
      });
    }).catchError((err) => err);
  }

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return isLoading
        ? LoadingCircle()
        : Consumer2<OrderProvider, GoodsProvider>(
            builder: (BuildContext context, OrderProvider provider,
                GoodsProvider goodsProvider, _) {
              // String dy = measureData?.verticalGroundHeight;

              return WillPopScope(
                  child: Scaffold(
                      appBar: AppBar(
                        title: Text('测装数据'),
                        centerTitle: true,
                      ),
                      body: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: UIKit.width(40),
                              vertical: UIKit.height(20)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  buildText(
                                      '空间:${measureData?.installRoom ?? ''}',
                                      width: (w - UIKit.width(40) * 2) / 2),
                                  buildText(
                                      '窗户类型:${measureData?.windowMeasureType ?? ''}'),
                                ],
                              ),
                              Container(
                                // alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(
                                    vertical: UIKit.height(10)),
                                child: buildText(
                                    '窗型:${measureData?.windowType ?? ''}'),
                              ),
                              Divider(
                                indent: UIKit.width(20),
                                endIndent: UIKit.width(20),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    buildText(
                                        '安装方式:${measureData?.installType ?? ''}',
                                        width: (w - UIKit.width(40) * 2) / 2),
                                    buildText(
                                        '型材类型:${measureData?.partsName ?? ''}'),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    buildText(
                                        '框内安装面宽度:${measureData?.frameWidth ?? '0'}cm'),
                                    buildText(
                                        '窗帘盒宽*高（cm）:${measureData?.curtainBoxSize ?? '0'}'),
                                    buildText(
                                        '顶/石膏线下到窗户上沿:${measureData?.topHeight ?? '0'}cm'),
                                  ],
                                ),
                              ),
                              Divider(
                                indent: UIKit.width(20),
                                endIndent: UIKit.width(20),
                              ),
                              Container(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        buildText(
                                            '离地距离:${goodsProvider?.dyCMStr ?? '0'}cm'),
                                        Text(hasChangedData(
                                                measureData
                                                    ?.verticalGroundHeight,
                                                goodsProvider?.dyCMStr)
                                            ? '原(${measureData?.verticalGroundHeight}cm)'
                                            : ''),
                                        InkWell(
                                          child: Icon(
                                            ZYIcon.edit,
                                            size: 14,
                                          ),
                                          onTap: () async {
                                            String tmp;
                                            await showCupertinoDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return CupertinoAlertDialog(
                                                    title: Text('离地距离(cm)'),
                                                    content: Column(
                                                      children: <Widget>[
                                                        CupertinoTextField(
                                                          placeholder:
                                                              '请输入离地距离(cm)',
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          onChanged:
                                                              (String text) {
                                                            tmp = text;
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    actions: <Widget>[
                                                      CupertinoDialogAction(
                                                        child: Text('取消'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                      CupertinoDialogAction(
                                                        child: Text('确定'),
                                                        onPressed: () {
                                                          goodsProvider?.dy =
                                                              tmp;
                                                          measureData
                                                                  ?.verticalGroundHeight =
                                                              tmp;
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      )
                                                    ],
                                                  );
                                                });
                                          },
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        buildText(
                                            '打开方式:${goodsProvider?.hasInitOpenMode == true ? goodsProvider?.curOpenMode : measureData?.openType}'),
                                        Text(goodsProvider?.hasInitOpenMode ==
                                                true
                                            ? goodsProvider?.curOpenMode !=
                                                    measureData?.openType
                                                ? '(原${measureData?.openType ?? ''})'
                                                : ''
                                            : ''),
                                        InkWell(
                                          child: Icon(
                                            ZYIcon.edit,
                                            size: 14,
                                          ),
                                          onTap: () {
                                            goodsProvider?.initWindowPattern(
                                                measureData?.windowType,
                                                measureData?.installType,
                                                measureData?.openType);
                                            RouteHandler.goEditOpenModePage(
                                                context);
                                          },
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
                                child: buildText(
                                    '测量备注记录:${measureData?.remark ?? ''}'),
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
                                      padding: EdgeInsets.symmetric(
                                          horizontal: UIKit.width(20)),
                                      child: ZYNetImage(
                                        imgPath: measureData?.picture ?? '',
                                        width: UIKit.width(200),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      bottomNavigationBar: ZYSubmitButton('确认', () {
                        provider?.hasConfirmMeasureData = true;
                        goodsProvider?.initSize(measureData);
                        goodsProvider?.hasInit = false;
                        // reset(provider);
                        Navigator.of(context).pop();
                      })),
                  onWillPop: () {
                    // reset(provider);
                    goodsProvider?.resetSize();
                    goodsProvider?.hasInitOpenMode = false;
                    provider?.hasConfirmMeasureData = false;
                    Navigator.of(context).pop();
                    return Future.value(false);
                  });
            },
          );
  }

  Widget buildText(String text, {double width}) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(vertical: UIKit.height(20)),
      child: Text(text ?? ''),
    );
  }

  bool hasChangedData(String h1, String h2) {
    return h1 != h2;
  }
}
