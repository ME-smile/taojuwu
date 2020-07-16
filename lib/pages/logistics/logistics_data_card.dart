import 'package:flutter/material.dart';

import 'package:taojuwu/models/logistics/logistics_data_model.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/copy_button.dart';
import 'package:taojuwu/widgets/photo_gallery.dart';

import 'package:taojuwu/widgets/v_spacing.dart';
import 'package:taojuwu/widgets/zy_expansion_panel.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';

class LogisticsDataCard extends StatelessWidget {
  final GoodsPacketModel model;
  const LogisticsDataCard({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (model?.hasDelivery == true)
      return HasDeliveredGoodsPacketCard(
        model: model,
      );
    if (model?.hasNotDelivered == true)
      return HasNotDelierveGoodsPacketCard(
        model: model,
      );
    return NoDelierveGoodsPacketCard(
      model: model,
    );
  }
}

class HasDeliveredGoodsPacketCard extends StatefulWidget {
  final GoodsPacketModel model;
  HasDeliveredGoodsPacketCard({Key key, this.model}) : super(key: key);

  @override
  _HasDeliveredGoodsPacketCardState createState() =>
      _HasDeliveredGoodsPacketCardState();
}

class _HasDeliveredGoodsPacketCardState
    extends State<HasDeliveredGoodsPacketCard> {
  GoodsPacketModel get model => widget.model;
  List<String> get imgList => model?.orderGoodsPictures ?? [];

  List<ExpressOrderModel> get expressOrderModels => model?.expressOrderModels;
  int get len => expressOrderModels?.length ?? 0;
  int get displayTrackLogCount => len < 3 ? len : 3;
  int get packetCount => model?.orderGoodsNum;
  List<ExpressOrderModel> get hiddenList =>
      expressOrderModels.length > 3 ? expressOrderModels?.sublist(3) : [];
  bool hasOpen = false;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return Container(
      color: themeData.primaryColor,
      padding: EdgeInsets.symmetric(
          horizontal: UIKit.width(20), vertical: UIKit.height(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                model?.packetName ?? '',
                style: textTheme.body1.copyWith(
                    fontSize: UIKit.sp(28),
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.bold),
              ),
              Text(
                model?.expressStatusName ?? '',
                style: TextStyle(color: Color(0xFFFF7676)),
              )
            ],
          ),
          Divider(),
          Gallery(
            imgList: imgList,
          ),
          Text(
            '快递公司:${model?.expressName ?? ''}',
            style: TextStyle(fontSize: UIKit.sp(26)),
          ),
          VSpacing(10),
          Row(
            children: <Widget>[
              Text(
                '快递单号:${model?.expressCode ?? ''}',
                style: TextStyle(fontSize: UIKit.sp(26)),
              ),
              CopyButton(model?.expressCode ?? '')
            ],
          ),
          VSpacing(10),
          Text(
            '共$packetCount件',
            style: textTheme.caption,
          ),
          VSpacing(10),
          Padding(
            padding: EdgeInsets.symmetric(vertical: UIKit.height(20)),
            child: Text(
              '快递信息',
              style: TextStyle(
                  fontSize: UIKit.sp(28), fontWeight: FontWeight.bold),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return ExpressOrderTrackLogItem(
                expressOrderModels[index],
                isFirst: index == 0,
                isOnlyOne: len == 1,
                isLast: index == 2 && hasOpen == false,
              );
            },
            itemCount: displayTrackLogCount,
          ),
          Offstage(
            offstage: len < 4,
            child: ZYExpansionPanel(
                title: Offstage(
                  offstage: hasOpen,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    margin: EdgeInsets.only(left: 70),
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF707070)),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Text(
                      '更多快递信息',
                      style: TextStyle(
                          color: Color(0xFF707070), fontSize: UIKit.sp(20)),
                    ),
                  ),
                ),
                onExpansionChanged: (bool flag) {
                  setState(() {
                    hasOpen = flag;
                  });
                },
                bottomAction: Offstage(
                  offstage: !hasOpen,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    margin: EdgeInsets.only(left: 70),
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF707070)),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Text(
                      '收起',
                      style: TextStyle(
                          color: Color(0xFF707070), fontSize: UIKit.sp(20)),
                    ),
                  ),
                ),
                initiallyExpanded: false,
                children: List.generate(hiddenList.length, (int i) {
                  var item = hiddenList[i];
                  return ExpressOrderTrackLogItem(
                    item,
                    isFirst: false,
                    // isOnlyOne: len == 1,
                    isLast: i == hiddenList.length - 1,
                  );
                })),
          ),
        ],
      ),
    );
  }
}

class NoDelierveGoodsPacketCard extends StatelessWidget {
  final GoodsPacketModel model;
  const NoDelierveGoodsPacketCard({Key key, this.model}) : super(key: key);

  List<String> get imgList => model?.orderGoodsPictures ?? [];
  int get goodsCount => model?.orderGoodsNum;
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return Container(
      color: themeData.primaryColor,
      padding: EdgeInsets.symmetric(
          horizontal: UIKit.width(20), vertical: UIKit.height(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                model?.packetName ?? '',
                style: textTheme.body1.copyWith(
                    fontSize: UIKit.sp(28),
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.bold),
              ),
              Text(
                model?.expressStatusName ?? '',
                style: TextStyle(color: Color(0xFFFF7676)),
              )
            ],
          ),
          VSpacing(20),
          Divider(),
          Gallery(
            imgList: imgList,
          ),
          Text(
            '共$goodsCount件',
            style: textTheme.caption,
          )
        ],
      ),
    );
  }
}

class HasNotDelierveGoodsPacketCard extends StatelessWidget {
  final GoodsPacketModel model;
  const HasNotDelierveGoodsPacketCard({Key key, this.model}) : super(key: key);

  List<String> get imgList => model?.orderGoodsPictures ?? [];
  int get goodsCount => model?.orderGoodsNum;
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return Container(
      color: themeData.primaryColor,
      padding: EdgeInsets.symmetric(
          horizontal: UIKit.width(20), vertical: UIKit.height(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                model?.packetName ?? '',
                style: textTheme.body1.copyWith(
                    fontSize: UIKit.sp(28),
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.bold),
              ),
              Text(
                model?.expressStatusName ?? '',
                style: TextStyle(color: Color(0xFFFF7676)),
              )
            ],
          ),
          VSpacing(20),
          Divider(),
          Gallery(
            imgList: imgList,
          ),
          Text(
            '共$goodsCount件',
            style: textTheme.caption,
          )
        ],
      ),
    );
  }
}

class Gallery extends StatelessWidget {
  final List<String> imgList;
  const Gallery({Key key, this.imgList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: UIKit.height(20)),
      height: UIKit.height(160),
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return ZYNetImage(
            height: UIKit.height(160),
            fit: BoxFit.fill,
            imgPath: imgList[index],
            callback: () {
              Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (
                    BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                  ) =>
                      PhotoGallery(
                        imgList: imgList,
                        index: index,
                        heroTag: imgList[index],
                      ),
                  transitionsBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation,
                          Widget child) =>
                      FadeTransition(
                        opacity: animation,
                        child: child,
                      )));
            },
          );
        },
        itemCount: imgList?.length ?? 0,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}

class ExpressOrderTrackLogItem extends StatefulWidget {
  final ExpressOrderModel model;
  final bool isFirst;
  final bool isLast;
  final bool isOnlyOne;
  ExpressOrderTrackLogItem(this.model,
      {Key key, this.isFirst: false, this.isLast: false, this.isOnlyOne: false})
      : super(key: key);

  @override
  _ExpressOrderTrackLogItemState createState() =>
      _ExpressOrderTrackLogItemState();
}

class _ExpressOrderTrackLogItemState extends State<ExpressOrderTrackLogItem> {
  ExpressOrderModel get model => widget.model;
  String get date => model?.acceptTime?.split(' ')?.first;
  String get time => model?.acceptTime?.split(' ')?.last;
  bool get isFirst => widget.isFirst;
  bool get isLast => widget.isLast;
  bool get isOnlyOne => widget.isOnlyOne;
  bool get titleIsEmpty =>
      model?.title == null || model?.title?.isEmpty == true;
  double height = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      RenderObject renderObject = context.findRenderObject();
      setState(() {
        height = (renderObject.semanticBounds.size.height) / 2;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 40,
            child: Text.rich(
              TextSpan(
                  text: '$date\n' ?? '-.--\n',
                  style: textTheme.caption.copyWith(fontSize: UIKit.sp(24)),
                  children: [
                    TextSpan(
                      text: time ?? '--:--',
                      style: textTheme.caption.copyWith(fontSize: UIKit.sp(20)),
                    ),
                  ]),
              textAlign: TextAlign.center,
            ),
          ),
          Column(
            children: <Widget>[
              Container(
                width: 1,
                height: height,
                color: isFirst ? Colors.transparent : Color(0xFFD3D3D3),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                    color: isFirst ? Color(0xFF242424) : Colors.white,
                    border: Border.all(
                      color: isFirst ? Colors.transparent : Color(0xFFD3D3D3),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
              ),
              Container(
                width: 1,
                height: height,
                color: isLast || isOnlyOne
                    ? Colors.transparent
                    : Color(0xFFD3D3D3),
              ),
            ],
          ),
          Expanded(
              child: Container(
                  alignment: Alignment.topCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox.fromSize(
                        size: Size.fromHeight(4),
                      ),
                      // Text.rich(TextSpan(text: model?.acceptStation ?? '--:--')),
                      Text.rich(TextSpan(
                          text: titleIsEmpty ? '' : '${model?.title}\n',
                          style: isFirst
                              ? TextStyle(
                                  fontSize: UIKit.sp(28),
                                  color: Color(0xFF333333))
                              : TextStyle(
                                  fontSize: UIKit.sp(28),
                                  color: Color(0xFF999999)),
                          children: [
                            TextSpan(
                                text: model?.acceptStation ?? '',
                                style: isFirst
                                    ? TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: UIKit.sp(24))
                                    : TextStyle(
                                        color: Color(0xFF999999),
                                        fontSize: UIKit.sp(24)))
                          ])),
                      SizedBox.fromSize(
                        size: Size.fromHeight(4),
                      )
                    ],
                  )))
        ],
      ),
    );
  }
}
