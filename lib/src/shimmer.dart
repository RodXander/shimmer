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
      builder: (_, child) {
        return _Shimmer(
          shader: ShimmerController.of(context)?.shader ??
              (throw ArgumentError("ShimmerController ancestor not found")),
          child: child,
        );
      },
      child: child,
    );
  }
}

class _Shimmer extends SingleChildRenderObjectWidget {
  const _Shimmer({
    Key? key,
    required this.shader,
    Widget? child,
  }) : super(key: key, child: child);

  final Shader shader;

  @override
  _ShimmerRenderObject createRenderObject(BuildContext context) {
    return _ShimmerRenderObject(shader);
  }
}

class _ShimmerRenderObject extends RenderProxyBox {
  _ShimmerRenderObject(this.shader);

  final Shader shader;

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
        ..shader = shader
        ..maskRect = offset & size
        ..blendMode = BlendMode.srcIn;
      paintingContext.pushLayer(layer!, super.paint, offset);
    } else {
      layer = null;
    }
  }
}
