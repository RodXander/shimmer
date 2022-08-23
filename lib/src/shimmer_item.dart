import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Widget that prepares [child] to receive the shimmer effect produced by [Shimmer].
/// [enabled] determines when [child] will show the shimmer effect.
/// [color] is to set the color against which the shimmer from [Shimmer] will be applied.
/// [borderRadius] sets the border radius of the shimmer over [child].
class ShimmerItem extends StatelessWidget {
  const ShimmerItem({
    Key? key,
    required this.child,
    this.borderRadius,
    this.color,
    this.enabled = true,
  }) : super(key: key);

  final Widget child;
  final bool enabled;
  final Color? color;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return enabled
        ? DecoratedBox(
            decoration: BoxDecoration(
              color: color,
              borderRadius: borderRadius,
            ),
            position: DecorationPosition.foreground,
            child: child,
          )
        : child;
  }
}
