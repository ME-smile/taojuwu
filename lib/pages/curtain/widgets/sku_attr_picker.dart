import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/zy_submit_button.dart';

class SkuAttrPicker extends StatelessWidget {
  final String title;
  final Function callback;
  final Widget child;
  SkuAttrPicker({this.title: '', this.child, this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(10), topLeft: Radius.circular(10)),
        child: Container(
            height: UIKit.height(600),
            alignment: Alignment.bottomCenter,
            width: double.infinity,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: UIKit.width(10), vertical: UIKit.height(20)),
                  child: Row(
                    children: <Widget>[
                      Expanded(child: SizedBox()),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: UIKit.TITLE_STYLE,
                      ),
                      Expanded(child: SizedBox()),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(ZYIcon.close),
                      ),
                    ],
                  ),
                ),
                Expanded(child: child),
                ZYSubmitButton('确定', () {
                  callback();
                })
                // Container(
                //   margin: EdgeInsets.symmetric(
                //     horizontal: UIKit.width(50),
                //   ),
                //    width: MediaQuery.of(context).size.width,
                //   child: RaisedButton(onPressed: (){
                //     callback();
                //   },child: Text(
                //       '确定',
                //       style: Theme.of(context).textTheme.button,),
                // )),
              ],
            )),
      ),
    );
  }
}
