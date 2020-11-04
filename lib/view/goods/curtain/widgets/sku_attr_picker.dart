/*
 * @Description: //弹窗
 * @Author: iamsmiling
 * @Date: 2020-09-25 12:47:45
 * @LastEditTime: 2020-11-02 15:14:44
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/zy_submit_button.dart';

class SkuAttrPicker extends StatelessWidget {
  final String title;
  final Function callback;
  final Widget child;
  final double height;
  final bool showButton;
  SkuAttrPicker(
      {this.title: '',
      this.child,
      this.callback,
      this.height = 480,
      this.showButton = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(10), topLeft: Radius.circular(10)),
        child: Stack(
          children: <Widget>[
            Container(
                height: height,
                alignment: Alignment.bottomCenter,
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    Visibility(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: UIKit.width(10),
                            vertical: UIKit.height(20)),
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: UIKit.TITLE_STYLE,
                        ),
                      ),
                      visible: !CommonKit.isNullOrEmpty(title),
                    ),
                    Expanded(child: child),
                    Visibility(
                      visible: showButton,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ZYSubmitButton('确定', () {
                          callback();
                        }),
                      ),
                    )
                  ],
                )),
            Positioned(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(ZYIcon.close),
              ),
              top: 10,
              right: 10,
            )
          ],
        ),
      ),
    );
  }
}
