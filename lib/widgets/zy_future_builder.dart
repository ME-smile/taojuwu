import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/constants/constants.dart';
import 'package:taojuwu/widgets/loading.dart';

import 'network_error.dart';

typedef ValueWidgetBuilder<T> = Widget Function(
  BuildContext context,
  T value,
);

// FutureBuilder 简单封装，除正确返回和错误外，其他返回 小菊花
/// 错误时返回定义好的错误 Widget，例如点击重新请求
class ZYFutureBuilder<T> extends StatefulWidget {
  final ValueWidgetBuilder<T> builder;
  final Function futureFunc;
  final Map<String, dynamic> params;
  final Widget loadingWidget;
  final GlobalKey key;
  ZYFutureBuilder(
      {@required this.futureFunc,
      @required this.builder,
      this.params,
      Widget loadingWidget,
      this.key})
      : loadingWidget = loadingWidget ?? LoadingCircle();

  @override
  _ZYFutureBuilderState<T> createState() => _ZYFutureBuilderState<T>();
}

class _ZYFutureBuilderState<T> extends State<ZYFutureBuilder<T>> {
  Future<T> _future;
  String oldParams = '';

  @override
  void initState() {
    super.initState();
    Future.delayed(Constants.TRANSITION_DURATION, () {
      request();
    });
    // WidgetsBinding.instance.addPostFrameCallback((CO) {
    //   request();
    // });
  }

  request() {
    if (mounted) {
      setState(() {
        if (widget.params == null)
          _future = widget.futureFunc(context);
        else {
          _future = widget.futureFunc(context, params: widget.params);
          oldParams = widget.params.values.join();
        }
      });
    }
  }

  @override
  void didUpdateWidget(ZYFutureBuilder<T> oldWidget) {
    // 如果方法不一样了，那么则重新请求
    if (oldWidget.futureFunc != widget.futureFunc) {
      WidgetsBinding.instance.addPostFrameCallback((call) {
        request();
      });
    }

    // 如果方法还一样，但是参数不一样了，则重新请求
    if ((oldWidget.futureFunc == widget.futureFunc) &&
        oldWidget.params != null &&
        widget.params != null) {
      if (oldParams != widget.params.values.join()) {
        oldParams = widget.params.values.join();
        WidgetsBinding.instance.addPostFrameCallback((call) {
          request();
        });
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return _future == null
        ? widget.loadingWidget
        : FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return widget.loadingWidget;
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    return widget.builder(context, snapshot.data);
                  } else if (snapshot.hasError) {
                    return NetworkErrorWidget(
                      callback: () {
                        request();
                      },
                    );
                  }
              }
              return Container();
            },
          );
  }
}
