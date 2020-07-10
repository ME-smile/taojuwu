import 'package:flutter/material.dart';

// import 'colors.dart';
// import 'icons.dart';
// import 'list_tile.dart';
// import 'theme.dart';
// import 'theme_data.dart';

// const Duration _kExpand = Duration(milliseconds: 500);

/// A single-line [ListTile] with a trailing button that expands or collapses
/// the tile to reveal or hide the [children].
///
/// This widget is typically used with [ListView] to create an
/// "expand / collapse" list entry. When used with scrolling widgets like
/// [ListView], a unique [PageStorageKey] must be specified to enable the
/// [ZYDropdownMenu] to save and restore its expanded state when it is scrolled
/// in and out of view.
///
/// See also:
///
///  * [ListTile], useful for creating expansion tile [children] when the
///    expansion tile represents a sublist.
///  * The "Expand/collapse" section of
///    <https://material.io/guidelines/components/lists-controls.html>.

// 分割线显示时机
enum DividerDisplayTime {
  always, //总是显示
  opened, //展开时显示
  closed, //关闭时显示
  never //不显示
}

class ZYDropdownMenu extends StatefulWidget {
  /// Creates a single-line [ListTile] with a trailing button that expands or collapses
  /// the tile to reveal or hide the [children]. The [initiallyExpanded] property must
  /// be non-null.
  const ZYDropdownMenu(
      {Key key,
      this.leading,
      @required this.title,
      this.backgroundColor,
      this.dividerColor,
      this.iconColor,
      this.dividerDisplayTime,
      this.onExpansionChanged,
      this.children = const <Widget>[],
      this.trailing,
      this.initiallyExpanded = false,
      this.height,
      this.showPanel = false,
      this.callbackWhenClosed})
      : assert(initiallyExpanded != null),
        super(key: key);

  /// A widget to display before the title.
  ///
  /// Typically a [CircleAvatar] widget.
  final Widget leading;

  final Function callbackWhenClosed;

  /// The primary content of the list item.
  ///
  /// Typically a [Text] widget.
  final String title;

  final double height;

  final bool showPanel;

  /// Called when the tile expands or collapses.
  ///
  /// When the tile starts expanding, this function is called with the value
  /// true. When the tile starts collapsing, this function is called with
  /// the value false.
  final ValueChanged<bool> onExpansionChanged;

  /// The widgets that are displayed when the tile expands.
  ///
  /// Typically [ListTile] widgets.
  final List<Widget> children;

  /// The color to display behind the sublist when expanded.
  final Color backgroundColor;

  /// A widget to display instead of a rotating arrow icon.
  final Widget trailing;

  /// Specifies if the list tile is initially expanded (true) or collapsed (false, the default).
  final bool initiallyExpanded;

  final Color dividerColor;

  final DividerDisplayTime dividerDisplayTime;

  final Color iconColor;

  @override
  ZYDropdownMenuState createState() => ZYDropdownMenuState();
}

class ZYDropdownMenuState extends State<ZYDropdownMenu>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.linear);

  final ColorTween _borderColorTween = ColorTween();

  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();

  AnimationController _controller;
  Animation<double> _heightFactor;

  bool _isExpanded = false;

  handleTap() {
    _handleTap();
  }

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _heightFactor = _controller.drive(_easeInTween);

    _isExpanded =
        PageStorage.of(context)?.readState(context) ?? widget.initiallyExpanded;
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.of(context)?.writeState(context, _isExpanded);
    });
    if (widget.onExpansionChanged != null)
      widget.onExpansionChanged(_isExpanded);
  }

  Widget _buildChildren(BuildContext context, Widget child) {
    // final Color borderSideColor = _borderColor.value ?? Colors.transparent;
    ThemeData themeData = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
          // color: _backgroundColor.value ?? Colors.transparent,
          color: themeData.primaryColor),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // height: widget.height ?? UIKit.height(60),
          // child: Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: <Widget>[
          // Offstage(
          //   offstage: !_isExpanded,
          //   child: Container(

          //     color: !_isExpanded ? Colors.transparent : Colors.white,
          //     padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
          //     child: Text(widget.title,
          //         style: textTheme.caption.copyWith(
          //             backgroundColor: Colors.white, fontSize: UIKit.sp(28))),
          //   ),
          // ),
          //     InkWell(
          //       onTap: _handleTap,
          //       child: Container(
          //         color: Colors.white,
          //         padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
          //         child: RotationTransition(
          //           turns: _iconTurns,
          //           child: const Icon(Icons.expand_more),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),

          ClipRect(
            child: Align(
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    setupDidvierColorTween();

    setupIconColorTween();

    setupBackgroundColor();

    super.didChangeDependencies();
  }

  void setupDidvierColorTween() {
    final ThemeData theme = Theme.of(context);

    Color beginColor = this.widget.dividerColor ?? theme.dividerColor;
    Color endColor = beginColor;

    switch (widget.dividerDisplayTime) {
      case DividerDisplayTime.always:
        break;
      case DividerDisplayTime.opened:
        endColor = Colors.transparent;
        break;
      case DividerDisplayTime.closed:
        beginColor = Colors.transparent;
        break;
      case DividerDisplayTime.never:
        beginColor = Colors.transparent;
        endColor = Colors.transparent;
        break;
      default:
    }
    _borderColorTween
      ..begin = beginColor
      ..end = endColor;
  }

  void setupIconColorTween() {
    final ThemeData theme = Theme.of(context);

    Color beginColor = this.widget.iconColor ?? theme.unselectedWidgetColor;
    Color endColor = beginColor;

    _iconColorTween
      ..begin = beginColor
      ..end = endColor;
  }

  void setupBackgroundColor() {
    _backgroundColorTween
      ..begin = widget.backgroundColor
      ..end = widget.backgroundColor;
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: closed ? null : Column(children: widget.children),
    );
  }
}
