import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/models/zy_response.dart';

import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/common_kit.dart';

import 'package:taojuwu/utils/ui_kit.dart';

class ScanButton extends StatelessWidget {
  const ScanButton({Key key}) : super(key: key);
  void scan(BuildContext context) async {
    try {
      ScanResult barcode = await BarcodeScanner.scan(
          options: ScanOptions(strings: {
        'cancel': '取消',
        'flash_on': '打开闪光灯',
        'flash_off': '关闭闪光灯'
      }));
      if (barcode != null) {
        List<String> splits = barcode?.rawContent?.split(',');
        String type = splits?.first;
        String model = splits?.last;
        OTPService.scanQR(params: {'type': type, 'model': model})
            .then((ZYResponse response) {
          if (response?.valid == true && response?.data != null) {
            RouteHandler.goCurtainDetailPage(
                context, response?.data['goods_id']);
          } else {
            // CommonKit.showToast('识别失败');
          }
        }).catchError((err) {
          CommonKit.showToast('识别出错');
        });
      } else {
        CommonKit.showToast('未识别的商品');
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        CommonKit.showToast('访问相机被拒绝');
      }
    } on FormatException catch (_) {
      // CommonKit.showToast('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: UIKit.width(15)),
        child: IconButton(
          icon: Icon(ZYIcon.scan),
          onPressed: () {
            scan(context);
          },
        ));
  }
}
