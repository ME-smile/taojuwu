import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/icon/ZYIcon.dart';

import 'package:taojuwu/utils/ui_kit.dart';

class ScanButton extends StatelessWidget {
  const ScanButton({Key key}) : super(key: key);
  void scan() async {
    ScanResult barcode = await BarcodeScanner.scan();
    print(barcode);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: UIKit.width(15)),
          child: IconButton(
            icon: ZYIcon.scan,
            onPressed: scan,
          )),
    );
  }
}
