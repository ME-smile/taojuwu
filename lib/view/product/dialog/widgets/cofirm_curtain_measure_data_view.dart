/*
 * @Description: 软装方案确认测装数据弹窗
 * @Author: iamsmiling
 * @Date: 2020-11-12 16:22:15
 * @LastEditTime: 2020-11-13 09:31:46
 */

import 'package:flutter/material.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/base_curtain_product_detail_bean.dart';
import 'package:taojuwu/widgets/zy_outline_button.dart';
import 'package:taojuwu/widgets/zy_raised_button.dart';

typedef FutureCallback = Future Function();

class CorfirmCurtainMeasureDataView extends StatelessWidget {
  final int count;
  final FutureCallback callback;
  const CorfirmCurtainMeasureDataView({Key key, this.count = 0, this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(16),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  margin: EdgeInsets.only(top: 16, bottom: 8),
                  child: Text(
                    '确认窗帘测装数据',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF333333)),
                  )),
              Text(
                '有$count个窗帘使用平台默认尺寸宽${BaseCurtainProductDetailBean?.defaultWidth}米、高${BaseCurtainProductDetailBean?.defaultHeight}米,实际以平台测量为准。若有自测尺寸,请修改测装数据。',
                style: TextStyle(fontSize: 14, color: const Color(0xFF6D6D6D)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ZYOutlineButton(
                      '返回修改',
                      () => Navigator.of(context).pop(),
                      verticalPadding: 8,
                    ),
                    // SizedBox(
                    //   width: 40,
                    // ),
                    ZYRaisedButton(
                      '确认',
                      () {
                        if (callback != null) {
                          callback().then((_) {
                            Navigator.of(context).pop();
                          });
                        }
                      },
                      horizontalPadding: 42,
                      verticalPadding: 8,
                    ),
                  ],
                ),
              )
            ],
          ),
          Positioned(
            child: GestureDetector(
              child: Icon(
                ZYIcon.close,
                size: 20,
                color: Colors.grey,
              ),
              onTap: () => Navigator.of(context).pop(),
            ),
            top: 0,
            right: 0,
          )
        ],
      ),
    );
  }
}
