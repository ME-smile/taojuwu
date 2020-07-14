import 'package:flutter/material.dart';
import 'package:taojuwu/application.dart';
import 'package:taojuwu/widgets/v_spacing.dart';
import 'package:taojuwu/widgets/zy_assetImage.dart';

class VersionPage extends StatelessWidget {
  const VersionPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('关于我们'),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            VSpacing(80),
            ZYAssetImage(
              'logo.png',
              width: 120,
              height: 120,
            ),
            VSpacing(20),
            Text('当前版本： ${Application.versionInfo}')
          ],
        ),
      ),
    );
  }
}
