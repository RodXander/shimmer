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

  @override
  State<ShimmerController> createState() => _ShimmerControllerState();
}

class _ShimmerControllerState extends State<ShimmerController>
    with SingleTickerProviderStateMixin {
  late AnimationController animation;
  late Map<double, Shader> cacheShader;

  Shader get shader {
    if (!cacheShader.containsKey(animation.value)) {
      var newShader = LinearGradient(
        colors: widget.gradient.colors,
        stops: widget.gradient.stops,
        begin: widget.gradient.begin,
        end: widget.gradient.end,
        transform: _SlidingGradientTransform(slidePercent: animation.value),
      ).createShader(
        Rect.fromLTWH(
          0,
          0,
          context.size?.width ?? 0,
          context.size?.height ?? 0,
        ),
      );
      cacheShader[animation.value] = newShader;
    }
    return cacheShader[animation.value]!;
  }

  @override
  void initState() {
    animation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
    super.initState();
  }

  @override
  void dispose() {
    animation.dispose();
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
  const _ShimmerControllerData({
    Key? key,
    required Widget child,
    required this.state,
  }) : super(key: key, child: child);

  final _ShimmerControllerState state;

  Animation get animation => state.animation;

  Shader get shader => state.shader;

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
