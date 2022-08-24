import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Widget that prepares [child] to receive the shimmer effect produced by [Shimmer].
///
/// [enabled] determines when [child] will show the shimmer effect.
/// [decoration] is the [Decoration] used to prepare [child] for a shimmer effect.
/// Use it to set borders and/or shapes, it must include a solid color for the shimmer effect to occur. Leave it null for a default decoration to be applied.
class ShimmerItem extends StatelessWidget {
  const ShimmerItem({
    Key? key,
    required this.child,
    this.decoration,
    this.enabled = true,
  }) : super(key: key);

  final Widget child;
  final bool enabled;
  final Decoration? decoration;

  @override
  Widget build(BuildContext context) {
    return enabled
        ? DecoratedBox(
            decoration: decoration ?? const BoxDecoration(color: Colors.black),
            position: DecorationPosition.foreground,
            child: child,
          )
        : child;
  }
}
