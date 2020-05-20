import 'package:flutter/material.dart';

class SendSmsButton extends StatefulWidget {
  final Function callback;
  SendSmsButton({Key key, this.callback}) : super(key: key);

  @override
  _SendSmsButtonState createState() => _SendSmsButtonState();
}

class _SendSmsButtonState extends State<SendSmsButton> {
  static bool _hasSend = false;
  Stream _stream = Stream.periodic(Duration(seconds: 1), (int curNum) {
    if (curNum == 120) {
      _hasSend = false;
      return 0;
    }
    return 120 - curNum--;
  });
  @override
  void dispose() {
    super.dispose();
    //force to close stream
    _stream = null;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme accentTextTheme = themeData.accentTextTheme;
    return !_hasSend
        ? RaisedButton(
            padding: EdgeInsets.all(0),
            child: Text(
              '获取验证码',
              style: accentTextTheme.button,
            ),
            onPressed: () {
              _hasSend = true;
              widget.callback();
            },
          )
        : StreamBuilder(
            stream: _stream,
            initialData: 120,
            builder: (BuildContext context, AsyncSnapshot stream) {
              return FlatButton(
                  onPressed: null, child: Text('${stream.data}s后重新发送'));
            });
  }
}
