import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shimmer/src/shimmer_controller.dart';

class Shimmer extends StatelessWidget {
  const Shimmer({Key? key, this.child}) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
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

      layer ??= ShaderMaskLayer();
      layer!
        ..shader = ShimmerController.of(_context)?.shader
        ..maskRect = offset & size
        ..blendMode = BlendMode.srcIn;
      paintingContext.pushLayer(layer!, super.paint, offset);
    } else {
      layer = null;
    }
  }
}
