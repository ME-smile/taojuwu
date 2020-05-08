import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/utils/ui_kit.dart';

class SkuAttrPicker extends StatelessWidget {
  final String title;
  final Function callback;
  final Widget child;
  SkuAttrPicker({this.title: '', this.child, this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: CupertinoColors.systemBackground.resolveFrom(context),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(UIKit.sp(20)),
              topLeft: Radius.circular(UIKit.sp(20)))),
      child: Material(
        child: Container(
            height: UIKit.height(600),
            alignment: Alignment.bottomCenter,
            width: double.infinity,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: UIKit.width(10),
                    vertical: UIKit.height(20)
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(child: SizedBox()),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                      ),
                      Expanded(child: SizedBox()),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: ZYIcon.close,
                      ),
                    ],
                  ),
                ),
                Expanded(child: child),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: UIKit.width(50),
                  ),
                   width: MediaQuery.of(context).size.width,
                  child: RaisedButton(onPressed: (){
                    callback();
                  },child: Text(
                      '确定',
                      style: Theme.of(context).textTheme.button,),
                )),
              ],
            )),
      ),
    );
  }
}
