import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
// import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/models/base/count_model.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/widgets/zy_assetImage.dart';

class StepCounter extends StatefulWidget {
  final int count;
  final CountModel model;
  final Function callback;
  StepCounter({Key key, this.count = 1, this.model, this.callback})
      : super(key: key);

  @override
  _StepCounterState createState() => _StepCounterState();
}

class _StepCounterState extends State<StepCounter> {
  CountModel get model => widget.model;
  Function get callback => widget.callback;
  TextEditingController textEditingController;

  int _count;

  int get count => _count;
  bool hasInit = false;
  set count(int count) {
    if (count <= 0) {
      CommonKit.showInfo('数量不能小于1哦');
      _count = 1;
    } else {
      _count = count;
    }
    model?.count = _count;

    if (callback != null && hasInit)
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        callback();
      });
    textEditingController?.text = '$_count';
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    count = widget.count;
    hasInit = true;
    textEditingController = TextEditingController(text: '${widget.count}');
    super.initState();
  }

  @override
  void dispose() {
    textEditingController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      child: ToggleButtons(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          constraints: BoxConstraints(maxWidth: 100),
          children: [
            InkWell(
              onTap: () {
                count--;
              },
              child: Padding(
                padding: EdgeInsets.all(6),
                child: ZYAssetImage(
                  'substract.png',
                  width: 10,
                  height: 10,
                  callback: () {
                    count--;
                  },
                ),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: 24, maxHeight: 24, minWidth: 56, maxWidth: 56),
              child: TextField(
                style: TextStyle(fontSize: 13),
                keyboardType: TextInputType.number,
                controller: textEditingController,
                textAlign: TextAlign.center,
                onSubmitted: (String text) {
                  count = NumUtil.getIntByValueStr(text);
                },
                maxLines: 1,
                decoration: InputDecoration(
                  isDense: true,
                  // enabledBorder: OutlineInputBorder(
                  //     borderRadius: BorderRadius.all(Radius.zero),
                  //     borderSide: BorderSide(width: .8, color: Color(0xFFCCCCCC))),
                  contentPadding: EdgeInsets.symmetric(vertical: 5),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                count++;
              },
              child: Padding(
                padding: EdgeInsets.all(6),
                child: ZYAssetImage(
                  'plus.png',
                  width: 10,
                  height: 10,
                  callback: () {
                    count++;
                  },
                ),
              ),
            )
          ],
          isSelected: [
            false,
            false,
            false
          ]),
    );
    //   return Container(
    //     width: 100,
    //     alignment: Alignment.center,
    //     child: Row(
    //       children: <Widget>[
    //         InkWell(
    //           child: Container(
    //             height: 20,
    //             child: Icon(
    //               ZYIcon.substract,
    //               size: 18,
    //             ),
    //           ),
    //           onTap: () {
    //             count--;
    //           },
    //         ),
    //         Expanded(
    //             child: Container(
    //           alignment: Alignment.center,

    //           // height: 20,
    //           constraints: BoxConstraints(maxHeight: 20, minHeight: 20),
    //           padding: EdgeInsets.only(top: 1, bottom: 1),
    //           child: TextField(
    //             keyboardType: TextInputType.number,
    //             controller: textEditingController,
    //             textAlign: TextAlign.center,
    //             onChanged: (String text) {
    //               count = NumUtil.getIntByValueStr(text);
    //             },
    //             decoration: InputDecoration(
    //               enabledBorder: OutlineInputBorder(
    //                   borderRadius: BorderRadius.all(Radius.zero),
    //                   borderSide:
    //                       BorderSide(width: .8, color: Color(0xFFCCCCCC))),
    //               contentPadding: const EdgeInsets.symmetric(vertical: 1.0),
    //             ),
    //           ),
    //         )),
    //         InkWell(
    //           child: Container(
    //             height: 20,
    //             child: Icon(
    //               ZYIcon.plus,
    //               size: 18,
    //             ),
    //           ),
    //           onTap: () {
    //             count++;
    //           },
    //         )
    //       ],
    //     ),
    //   );
    // }
  }
}
