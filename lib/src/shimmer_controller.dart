import 'dart:collection';

import 'package:flutter/material.dart';

class ShimmerController extends StatefulWidget {
  const ShimmerController({
    Key? key,
    required this.child,
    required this.gradient,
  }) : super(key: key);

  final Widget child;
  final LinearGradient gradient;

  // ignore: library_private_types_in_public_api
  static _ShimmerControllerData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_ShimmerControllerData>();
  }

  // ignore: library_private_types_in_public_api
  static _ShimmerControllerData? find(BuildContext context) {
    return context.findAncestorWidgetOfExactType<_ShimmerControllerData>();
  }

  @override
  State<ShimmerController> createState() => _ShimmerControllerState();
}

class _ShimmerControllerState extends State<ShimmerController>
    with SingleTickerProviderStateMixin {
  late Animation _animation;
  late AnimationController _animationController;

  LinearGradient get _gradient => LinearGradient(
        colors: widget.gradient.colors,
        stops: widget.gradient.stops,
        begin: widget.gradient.begin,
        end: widget.gradient.end,
        transform: _SlidingGradientTransform(slidePercent: _animation.value),
      );
  Size get _size => context.size!;

  Offset getDescendantOffset(RenderBox descendant) => descendant.localToGlobal(
        Offset.zero,
        ancestor: context.findRenderObject(),
      );

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = Tween(begin: -0.5, end: 1.5).animate(_animationController);

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ShimmerControllerData(
      state: this,
      child: widget.child,
    );
  }
}

class _ShimmerControllerData extends InheritedWidget {
  _ShimmerControllerData({
    Key? key,
    required Widget child,
    required this.state,
  }) : super(key: key, child: child);

  final HashSet<BuildContext> _shimmers = HashSet();
  final _ShimmerControllerState state;

  LinearGradient get gradient => state._gradient;
  Animation get animation => state._animation;
  Offset getDescendantOffset(RenderBox descendant) =>
      state.getDescendantOffset(descendant);
  Size get size => state._size;

  void registerShimmer(BuildContext context) {
    _shimmers.add(context);
    if (_shimmers.isNotEmpty && !state._animationController.isAnimating) {
      state._animationController.repeat();
    }
  }

  void unregisterShimmer(BuildContext context) {
    _shimmers.remove(context);
    if (_shimmers.isEmpty && state._animationController.isAnimating) {
      state._animationController.reset();
    }
  }

  @override
  bool updateShouldNotify(_ShimmerControllerData oldWidget) =>
      this != oldWidget;

  Widget build(BuildContext context) => child;
}

/// Represents the [GradientTransform] to be applied on the [Shimmer] object.
///
/// This allows to transform the [LinearGradient] used as shimmer in regard with the animation and represent the shimmer moving.
class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({
    required this.slidePercent,
  });

  /// Gets the percentage of horizontal translation for the [GradientTransform].
  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}
