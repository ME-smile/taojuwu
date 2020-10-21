import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'animated_dropdown_drawer.dart';

Future showModalPopdown({
  BuildContext context,
  Widget child,
}) {
  return Navigator.push(context, PopDownRoute(child));
}

class PopDownRoute extends TransitionRoute {
  final bool barrierDismissible;
  final bool maintainState;
  final Color barrierColor;
  final bool semanticsDismissible;
  final Duration animationDuration;
  final Widget child;
  final double offsetY;
  final Function closedCallback;
  final GlobalKey<AniamatedDropdownDrawerState> drawerKey;
  PopDownRoute(this.child,
      {this.barrierDismissible = true,
      this.maintainState = false,
      this.semanticsDismissible = true,
      this.offsetY = 0.0,
      this.drawerKey,
      this.closedCallback,
      this.animationDuration = const Duration(milliseconds: 375),
      this.barrierColor = Colors.black54});

  OverlayEntry modalbarrier;
  OverlayEntry modalScope;
  Color _kTransparent = Color(0x00000000);
  bool get offstage => _offstage;
  bool _offstage = false;
  Curve get barrierCurve => Curves.ease;

  @override
  Iterable<OverlayEntry> createOverlayEntries() sync* {
    yield modalbarrier = OverlayEntry(builder: _buildMask);
    yield modalScope =
        OverlayEntry(builder: _buildModalScope, maintainState: maintainState);
  }

  Widget _buildMask(BuildContext context) {
    Widget barrier;
    if (barrierColor != null && !offstage) {
      // changedInternalState is called if barrierColor or offstage updates
      assert(barrierColor != _kTransparent);
      final Animation<Color> color = animation.drive(
        ColorTween(
          begin: _kTransparent,
          end:
              barrierColor, // changedInternalState is called if barrierColor updates
        ).chain(CurveTween(
            curve:
                barrierCurve)), // changedInternalState is called if barrierCurve updates
      );
      barrier = AnimatedMask(
        color: color,
        callback: () {
          if (closedCallback != null) closedCallback();
          drawerKey.currentState.close();
        },
        dismissible:
            barrierDismissible, // changedInternalState is called if barrierDismissible updates
        // changedInternalState is called if barrierLabel updates
        barrierSemanticsDismissible: semanticsDismissible,
      );
    }

    barrier = IgnorePointer(
      ignoring: animation.status ==
              AnimationStatus
                  .reverse || // changedInternalState is called when animation.status updates
          animation.status ==
              AnimationStatus
                  .dismissed, // dismissed is possible when doing a manual pop gesture
      child: barrier,
    );

    return Positioned(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: barrier,
      ),
      top: offsetY,
    );
  }

  Widget _buildModalScope(BuildContext context) {
    return Positioned(
      child: AniamatedDropdownDrawer(
        key: drawerKey,
        child: child,
      ),
      top: offsetY,
    );
  }

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => animationDuration;
}

// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// A widget that prevents the user from interacting with widgets behind itself.
///
/// The modal barrier is the scrim that is rendered behind each route, which
/// generally prevents the user from interacting with the route below the
/// current route, and normally partially obscures such routes.
///
/// For example, when a dialog is on the screen, the page below the dialog is
/// usually darkened by the modal barrier.
///
/// See also:
///
///  * [ModalRoute], which indirectly uses this widget.
///  * [AnimatedMask], which is similar but takes an animated [color]
///    instead of a single color value.
class Mask extends StatelessWidget {
  /// Creates a widget that blocks user interaction.
  const Mask({
    Key key,
    this.color,
    this.dismissible = true,
    this.semanticsLabel,
    this.callback,
    this.barrierSemanticsDismissible = true,
  }) : super(key: key);

  /// If non-null, fill the barrier with this color.
  ///
  /// See also:
  ///
  ///  * [ModalRoute.barrierColor], which controls this property for the
  ///    [Mask] built by [ModalRoute] pages.
  final Color color;
  final Function callback;

  /// Whether touching the barrier will pop the current route off the [Navigator].
  ///
  /// See also:
  ///
  ///  * [ModalRoute.barrierDismissible], which controls this property for the
  ///    [Mask] built by [ModalRoute] pages.
  final bool dismissible;

  /// Whether the modal barrier semantics are included in the semantics tree.
  ///
  /// See also:
  ///
  ///  * [ModalRoute.semanticsDismissible], which controls this property for
  ///    the [Mask] built by [ModalRoute] pages.
  final bool barrierSemanticsDismissible;

  /// Semantics label used for the barrier if it is [dismissible].
  ///
  /// The semantics label is read out by accessibility tools (e.g. TalkBack
  /// on Android and VoiceOver on iOS) when the barrier is focused.
  ///
  /// See also:
  ///
  ///  * [ModalRoute.barrierLabel], which controls this property for the
  ///    [Mask] built by [ModalRoute] pages.
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    assert(!dismissible ||
        semanticsLabel == null ||
        debugCheckHasDirectionality(context));
    bool platformSupportsDismissingBarrier;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        platformSupportsDismissingBarrier = false;
        break;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        platformSupportsDismissingBarrier = true;
        break;
    }
    assert(platformSupportsDismissingBarrier != null);
    final bool semanticsDismissible =
        dismissible && platformSupportsDismissingBarrier;
    // ignore: non_constant_identifier_names
    final bool MaskSemanticsDismissible =
        barrierSemanticsDismissible ?? semanticsDismissible;
    return BlockSemantics(
      child: ExcludeSemantics(
        // On Android, the back button is used to dismiss a modal. On iOS, some
        // modal barriers are not dismissible in accessibility mode.
        excluding: !semanticsDismissible || !MaskSemanticsDismissible,
        child: _MaskGestureDetector(
          onDismiss: () {
            if (dismissible) Navigator.maybePop(context);
            if (callback != null) callback();
          },
          child: Semantics(
            label: semanticsDismissible ? semanticsLabel : null,
            textDirection: semanticsDismissible && semanticsLabel != null
                ? Directionality.of(context)
                : null,
            child: MouseRegion(
              cursor: SystemMouseCursors.basic,
              opaque: true,
              child: ConstrainedBox(
                constraints: const BoxConstraints.expand(),
                child: color == null
                    ? null
                    : DecoratedBox(
                        decoration: BoxDecoration(
                          color: color,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A widget that prevents the user from interacting with widgets behind itself,
/// and can be configured with an animated color value.
///
/// The modal barrier is the scrim that is rendered behind each route, which
/// generally prevents the user from interacting with the route below the
/// current route, and normally partially obscures such routes.
///
/// For example, when a dialog is on the screen, the page below the dialog is
/// usually darkened by the modal barrier.
///
/// This widget is similar to [Mask] except that it takes an animated
/// [color] instead of a single color.
///
/// See also:
///
///  * [ModalRoute], which uses this widget.
class AnimatedMask extends AnimatedWidget {
  /// Creates a widget that blocks user interaction.
  const AnimatedMask({
    Key key,
    Animation<Color> color,
    this.dismissible = true,
    this.semanticsLabel,
    this.callback,
    this.barrierSemanticsDismissible,
  }) : super(key: key, listenable: color);

  /// If non-null, fill the barrier with this color.
  ///
  /// See also:
  ///
  ///  * [ModalRoute.barrierColor], which controls this property for the
  ///    [AnimatedMask] built by [ModalRoute] pages.
  Animation<Color> get color => listenable as Animation<Color>;
  final Function callback;

  /// Whether touching the barrier will pop the current route off the [Navigator].
  ///
  /// See also:
  ///
  ///  * [ModalRoute.barrierDismissible], which controls this property for the
  ///    [AnimatedMask] built by [ModalRoute] pages.
  final bool dismissible;

  /// Semantics label used for the barrier if it is [dismissible].
  ///
  /// The semantics label is read out by accessibility tools (e.g. TalkBack
  /// on Android and VoiceOver on iOS) when the barrier is focused.
  /// See also:
  ///
  ///  * [ModalRoute.barrierLabel], which controls this property for the
  ///    [Mask] built by [ModalRoute] pages.
  final String semanticsLabel;

  /// Whether the modal barrier semantics are included in the semantics tree.
  ///
  /// See also:
  ///
  ///  * [ModalRoute.semanticsDismissible], which controls this property for
  ///    the [Mask] built by [ModalRoute] pages.
  final bool barrierSemanticsDismissible;

  @override
  Widget build(BuildContext context) {
    return Mask(
      color: color?.value,
      dismissible: dismissible,
      semanticsLabel: semanticsLabel,
      callback: callback,
      barrierSemanticsDismissible: barrierSemanticsDismissible,
    );
  }
}

// Recognizes tap down by any pointer button.
//
// It is similar to [TapGestureRecognizer.onTapDown], but accepts any single
// button, which means the gesture also takes parts in gesture arenas.
class _AnyTapGestureRecognizer extends BaseTapGestureRecognizer {
  _AnyTapGestureRecognizer({Object debugOwner}) : super(debugOwner: debugOwner);

  VoidCallback onAnyTapUp;

  @protected
  @override
  bool isPointerAllowed(PointerDownEvent event) {
    if (onAnyTapUp == null) return false;
    return super.isPointerAllowed(event);
  }

  @override
  String get debugDescription => 'any tap';

  @override
  void handleTapCancel(
      {PointerDownEvent down, PointerCancelEvent cancel, String reason}) {}

  @override
  void handleTapDown({PointerDownEvent down}) {}

  @override
  void handleTapUp({PointerDownEvent down, PointerUpEvent up}) {}
}

class _MaskSemanticsDelegate extends SemanticsGestureDelegate {
  const _MaskSemanticsDelegate({this.onDismiss});

  final VoidCallback onDismiss;

  @override
  void assignSemantics(RenderSemanticsGestureHandler renderObject) {
    renderObject.onTap = onDismiss;
  }
}

class _AnyTapGestureRecognizerFactory
    extends GestureRecognizerFactory<_AnyTapGestureRecognizer> {
  const _AnyTapGestureRecognizerFactory({this.onAnyTapUp});

  final VoidCallback onAnyTapUp;

  @override
  _AnyTapGestureRecognizer constructor() => _AnyTapGestureRecognizer();

  @override
  void initializer(_AnyTapGestureRecognizer instance) {
    instance.onAnyTapUp = onAnyTapUp;
  }
}

// A GestureDetector used by Mask. It only has one callback,
// [onAnyTapDown], which recognizes tap down unconditionally.
class _MaskGestureDetector extends StatelessWidget {
  const _MaskGestureDetector({
    Key key,
    @required this.child,
    @required this.onDismiss,
  })  : assert(child != null),
        assert(onDismiss != null),
        super(key: key);

  /// The widget below this widget in the tree.
  /// See [RawGestureDetector.child].
  final Widget child;

  /// Immediately called when an event that should dismiss the modal barrier
  /// has happened.
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final Map<Type, GestureRecognizerFactory> gestures =
        <Type, GestureRecognizerFactory>{
      _AnyTapGestureRecognizer:
          _AnyTapGestureRecognizerFactory(onAnyTapUp: onDismiss),
    };

    return RawGestureDetector(
      gestures: gestures,
      behavior: HitTestBehavior.opaque,
      semantics: _MaskSemanticsDelegate(onDismiss: onDismiss),
      child: child,
    );
  }
}
