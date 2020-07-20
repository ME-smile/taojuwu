import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/utils/common_kit.dart';

class StepCounter extends StatefulWidget {
  final int count;
  final Function callback;
  StepCounter({Key key, this.count = 1, this.callback}) : super(key: key);

  @override
  _StepCounterState createState() => _StepCounterState();
}

class _StepCounterState extends State<StepCounter> {
  Function get callback => widget.callback;

  TextEditingController textEditingController;

  int _count;

  int get count => _count;
  set count(int count) {
    if (count <= 0) {
      CommonKit.showInfo('数量不能小于0哦');
      _count = 1;
    } else {
      _count = count;
    }

    if (callback != null) callback();
    textEditingController?.text = '$_count';
    setState(() {});
  }

  @override
  void initState() {
    count = widget.count;
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
      width: 100,
      alignment: Alignment.center,
      child: Row(
        children: <Widget>[
          InkWell(
            child: Container(
              height: 20,
              child: Icon(
                ZYIcon.substract,
                size: 20,
              ),
            ),
            onTap: () {
              count--;
            },
          ),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.symmetric(
                    vertical: BorderSide(width: .5, color: Color(0xFFCCCCCC)))),
            width: 52,
            height: 20,
            child: TextField(
              keyboardType: TextInputType.number,
              controller: textEditingController,
              textAlign: TextAlign.center,
              onChanged: (String text) {
                count = NumUtil.getIntByValueStr(text);
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
              ),
            ),
          ),
          InkWell(
            child: Container(
              height: 20,
              child: Icon(
                ZYIcon.plus,
                size: 20,
              ),
            ),
            onTap: () {
              count++;
            },
          )
        ],
      ),
    );
  }
}
