import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shimmer/src/shimmer_controller.dart';

class Shimmer extends StatelessWidget {
  const Shimmer({
    Key? key,
    this.enabled = true,
    required this.child,
  }) : super(key: key);

  final bool enabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return child;
    }

    return AnimatedBuilder(
      animation: ShimmerController.of(context)?.animation ??
          (throw ArgumentError("ShimmerController ancestor not found")),
      builder: (_, child) => _Shimmer(child: child),
      child: child,
    );
  }
}

class _Shimmer extends SingleChildRenderObjectWidget {
  const _Shimmer({
    Key? key,
    Widget? child,
  }) : super(key: key, child: child);

  @override
  _ShimmerRenderObject createRenderObject(BuildContext context) {
    return _ShimmerRenderObject(context);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderObject renderObject) {
    renderObject.markNeedsPaint();
    super.updateRenderObject(context, renderObject);
  }
}

class _ShimmerRenderObject extends RenderProxyBox {
  _ShimmerRenderObject(this._context);

  final BuildContext _context;

  @override
  ShaderMaskLayer? get layer => super.layer as ShaderMaskLayer?;

  @override
  bool get alwaysNeedsCompositing => child != null;

  @override
  void paint(PaintingContext paintingContext, Offset offset) {
    if (child != null) {
      assert(needsCompositing);

      var offsetInShimmerController = ShimmerController.of(_context)
              ?.getDescendantOffset(_context.findRenderObject() as RenderBox) ??
          (throw ArgumentError("ShimmerController ancestor not found"));
      var sizeOfShimmerController = ShimmerController.of(_context)?.size ??
          (throw ArgumentError("ShimmerController ancestor not found"));

      layer ??= ShaderMaskLayer();
      layer!
        ..shader = ShimmerController.of(_context)?.gradient.createShader(
                  Rect.fromLTWH(
                    -offsetInShimmerController.dx,
                    -offsetInShimmerController.dy,
                    sizeOfShimmerController.width,
                    sizeOfShimmerController.height,
                  ),
                ) ??
            (throw ArgumentError("ShimmerController ancestor not found"))
        ..maskRect = offset & size
        ..blendMode = BlendMode.srcATop;
      paintingContext.pushLayer(layer!, super.paint, offset);
    } else {
      layer = null;
    }
  }
}
