import 'package:flutter/material.dart';
import 'package:paper_liquid_metal_logo/liquid_metal_logo_state.dart';
import 'package:provider/provider.dart';
import 'package:vector_graphics/vector_graphics_compat.dart';

class LogoSelector extends StatefulWidget {
  const LogoSelector({super.key});

  @override
  State<LogoSelector> createState() => _LogoSelectorState();
}

class _LogoSelectorState extends State<LogoSelector> {
  final _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      controller: _controller,
      trackVisibility: true,
      thumbVisibility: true,
      thickness: 6,
      radius: const Radius.circular(3),
      trackRadius: const Radius.circular(3),
      thumbColor: const Color(0xFF666666),
      trackColor: const Color(0xFF292929),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      scrollbarOrientation: ScrollbarOrientation.bottom,
      child: SingleChildScrollView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        child: Builder(
          builder: (context) {
            final windowSize = MediaQuery.sizeOf(context);

            return ConstrainedBox(
              constraints: BoxConstraints(minWidth: windowSize.width),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 32,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (final type in LiquidMetalLogoType.values)
                      _Item(type: type),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Item extends StatefulWidget {
  const _Item({
    required this.type,
  });

  final LiquidMetalLogoType type;

  @override
  State<_Item> createState() => __ItemState();
}

class __ItemState extends State<_Item> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );

  late final Animation<double> _logoOpacity = Tween<double>(
    begin: 0.4,
    end: 1,
  ).chain(CurveTween(curve: Curves.easeInOut)).animate(_controller);

  late final Animation<Color?> _borderColor = ColorTween(
    begin: const Color(0x00FFFFFF),
    end: const Color(0x66FFFFFF),
  ).chain(CurveTween(curve: Curves.easeInOut)).animate(_controller);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: GestureDetector(
        onTap: () {
          context.read<LiquidMetalLogoState>().type = widget.type;
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            RepaintBoundary(
              child: SizedBox(
                width: 160,
                height: 100,
                child: AnimatedBuilder(
                  animation: _borderColor,
                  builder: (context, child) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        border: Border.fromBorderSide(
                          BorderSide(color: _borderColor.value!),
                        ),
                      ),
                      child: child,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: VectorGraphic(
                      loader: AssetBytesLoader(widget.type.icon),
                      opacity: _logoOpacity,
                      height: 52,
                      width: 112,
                      fit: BoxFit.fitHeight,
                      placeholderBuilder: (_) => const SizedBox.shrink(
                        key: Key(''),
                      ),
                      transitionDuration: const Duration(milliseconds: 250),
                    ),
                  ),
                ),
              ),
            ),
            Text(
              widget.type.label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                height: 24 / 16,
                letterSpacing: -0.7,
                color: Color(0xB2FFFFFF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
