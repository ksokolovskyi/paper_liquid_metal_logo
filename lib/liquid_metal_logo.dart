import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:paper_liquid_metal_logo/liquid_metal_logo_state.dart';
import 'package:paper_liquid_metal_logo/liquid_metal_shader_controller.dart';
import 'package:provider/provider.dart';

class LiquidMetalLogo extends StatefulWidget {
  const LiquidMetalLogo({super.key});

  @override
  State<LiquidMetalLogo> createState() => _LiquidMetalLogoState();
}

class _LiquidMetalLogoState extends State<LiquidMetalLogo> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<LiquidMetalLogoState>();

    return RepaintBoundary(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          gradient: state.background.gradient,
        ),
        child: const _Logo(),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    final controller = context.read<LiquidMetalShaderController>();

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 500,
        maxWidth: 500,
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: AspectRatio(
              aspectRatio: 1,
              child: ListenableBuilder(
                listenable: Listenable.merge(controller.parameters),
                builder: (context, child) {
                  return ShaderBuilder(
                    assetKey: 'assets/shaders/liquid.frag',
                    (context, shader, _) {
                      return AnimatedSampler(
                        (image, size, canvas) {
                          shader
                            ..setImageSampler(0, image)
                            ..setFloatUniforms((uniforms) {
                              uniforms
                                ..setSize(size)
                                // u_time
                                ..setFloat(controller.time.value)
                                // u_ratio
                                ..setFloat(1)
                                // u_img_ratio
                                ..setFloat(1)
                                // u_patternScale
                                ..setFloat(controller.patternScale.value)
                                // u_refraction
                                ..setFloat(controller.dispersion.value)
                                // u_edge
                                ..setFloat(controller.edge.value)
                                // u_patternBlur
                                ..setFloat(controller.patternBlur.value)
                                // u_liquid
                                ..setFloat(controller.liquid.value);
                            });

                          canvas.drawRect(
                            Rect.fromLTWH(0, 0, size.width, size.height),
                            Paint()..shader = shader,
                          );
                        },
                        child: child!,
                      );
                    },
                  );
                },
                child: const _Image(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Image extends StatefulWidget {
  const _Image();

  @override
  State<_Image> createState() => _ImageState();
}

class _ImageState extends State<_Image> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
    reverseDuration: const Duration(milliseconds: 300),
  );

  late final _opacity = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
    reverseCurve: Curves.easeIn,
  );

  late final LiquidMetalLogoState _state;

  late LiquidMetalLogoType _type;

  LiquidMetalLogoType? _nextType;

  @override
  void initState() {
    super.initState();

    _state = context.read<LiquidMetalLogoState>();
    _state.addListener(_onTypeChanged);

    _type = _state.type;

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _opacity.dispose();

    _state.removeListener(_onTypeChanged);

    super.dispose();
  }

  Future<void> _onTypeChanged() async {
    final nextType = _state.type;

    if (nextType == _type || nextType == _nextType) {
      return;
    }

    _nextType = nextType;

    await _controller.reverse();

    if (!mounted || _nextType != nextType) {
      return;
    }

    setState(() {
      _type = nextType;
      _nextType = null;
    });

    _controller.reset();
    unawaited(_controller.forward());
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Image.asset(
        _type.asset,
        opacity: _opacity,
      ),
    );
  }
}
