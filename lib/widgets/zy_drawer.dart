import 'package:flutter/material.dart';

class ZYDrawer extends StatefulWidget {
  final bool isNeedMask;
  final double offsetY;
  final double width;
  ZYDrawer({Key key, this.isNeedMask: true, this.offsetY, this.width: 200})
      : super(key: key);

  @override
  _ZYDrawerState createState() => _ZYDrawerState();
}

class _ZYDrawerState extends State<ZYDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          widget.isNeedMask ? _mask() : Container(),
          _DragContainer(
            offsetY: widget.offsetY,
            width: widget.width,
          )
        ],
      ),
    );
  }

  Widget _mask() {
    return Container(
      margin: EdgeInsets.only(top: widget.offsetY),
      width: MediaQuery.of(context).size.width,
      height: double.infinity,
      color: Color.fromRGBO(0, 0, 0, 0.5),
    );
  }
}

class _DragContainer extends StatefulWidget {
  final double offsetY;
  final double width;
  _DragContainer({Key key, this.offsetY, this.width}) : super(key: key);

  @override
  __DragContainerState createState() => __DragContainerState();
}

class __DragContainerState extends State<_DragContainer>
    with SingleTickerProviderStateMixin {
  // double  = 0.0;
  AnimationController controller;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Transform.translate(
      offset: Offset(width, widget.offsetY),
      child: Container(
        child: Text('data'),
      ),
    );
  }
}
