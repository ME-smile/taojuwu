import 'package:flutter/material.dart';
import 'package:taojuwu/providers/goods_provider.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/triangle_clipper.dart';

class WindowPatternView extends StatefulWidget {
  final String text;
  final List<Map<String, String>> imgs;
  final int curOpotion;
  final Function callback;
  final GoodsProvider provider;
  WindowPatternView(
      {Key key,
      this.text: '',
      this.imgs,
      this.curOpotion: 0,
      this.callback,
      this.provider})
      : super(key: key);

  @override
  _WindowPatternViewState createState() => _WindowPatternViewState();
}

class _WindowPatternViewState extends State<WindowPatternView> {
  GoodsProvider provider;
  int curOption;
  @override
  void initState() {
    super.initState();
    provider = widget.provider;
    curOption = widget.curOpotion;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: UIKit.height(20)),
          child: Text(widget.text),
        ),
        Row(
          children: List.generate(widget.imgs.length, (int i) {
            bool isChecked = curOption == i;
            return GestureDetector(
              child: Container(
                width: UIKit.width(150),
                height: UIKit.width(150),
                margin: EdgeInsets.only(right: UIKit.width(20)),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            UIKit.getAssetsImagePath(widget.imgs[i]['img']))),
                    border: Border.all(
                        color: isChecked
                            ? Theme.of(context).accentColor
                            : Colors.grey,
                        width: 2)),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: isChecked ? TriAngle() : Container(),
                ),
              ),
              onTap: () {
                switch (widget.text) {
                  case '样式':
                    setState(() {
                      curOption = i;
                    });
                    provider?.tmpWindowPattern = i;
                    break;
                  case '窗型选择':
                    setState(() {
                      curOption = i;
                    });
                    provider?.tmpWindowStyle = i;
                    break;
                  case '窗帘盒':
                    setState(() {
                      curOption = i;
                    });
                    provider?.tmpWindowType = i;
                    break;
                  default:
                }
              },
            );
          }),
        ),
      ],
    );
  }
}
