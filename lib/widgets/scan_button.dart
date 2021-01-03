import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/repository/zy_response.dart';

import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/toast_kit.dart';

import 'package:taojuwu/utils/ui_kit.dart';

class ScanButton extends StatelessWidget {
  const ScanButton({Key key}) : super(key: key);

  jump(BuildContext context, int type, int id) {
    if (type == 1) {
      return RouteHandler.goFabricCurtainProductDetailPage(
        context,
        id,
      );
    }
    if (type == 2) {
      return RouteHandler.goRollingCurtainProductDetailPage(context, id,
          isMeasureOrderGoods: 0);
    }
    if (type == 3) {
      return RouteHandler.goGauzeCurtainProductDetailPage(context, id,
          isMeasureOrderGoods: 0);
    }
    if (type == 4) {
      return RouteHandler.goSectionalbarProductDetailPage(context, id,
          isMeasureOrderGoods: 0);
    }
  }

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
            int type = response?.data['goods_type'];
            int id = response?.data['goods_id'];
            jump(context, type, id);
          } else {
            ToastKit.showToast('二维码无效');
          }
        }).catchError((err) {
          ToastKit.showToast('识别出错');
        });
      } else {
        ToastKit.showToast('未识别的商品');
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        ToastKit.showToast('访问相机被拒绝');
      }
    } on FormatException catch (_) {
      // ToastKit.showToast('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(right: UIKit.width(15)),
        child: IconButton(
          icon: Icon(
            ZYIcon.scan,
            size: 18,
          ),
          onPressed: () {
            scan(context);
          },
        ));
  }
}
