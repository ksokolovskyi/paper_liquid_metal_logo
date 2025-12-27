import 'package:flutter/material.dart';

class SimpleSlider extends StatelessWidget {
  const SimpleSlider({
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
    super.key,
  });

  final double value;

  final double minValue;

  final double maxValue;

  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 40),
      child: SliderTheme(
        data: const SliderThemeData(
          thumbShape: HandleThumbShape(),
          thumbSize: WidgetStatePropertyAll(Size.square(16)),
          thumbColor: Colors.white,
          trackHeight: 6,
          trackShape: _TrackShape(),
          overlayShape: _NoOverlayShape(),
        ),
        child: Slider(
          padding: EdgeInsets.zero,
          value: value,
          min: minValue,
          max: maxValue,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _TrackShape extends SliderTrackShape with BaseSliderTrackShape {
  const _TrackShape();

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
  }) {
    final trackHeight = sliderTheme.trackHeight!;
    final activePaint = Paint()..color = const Color(0xFF81ADEC);
    final inactivePaint = Paint()..color = const Color(0x33FFFFFF);
    final (
      Paint leftTrackPaint,
      Paint rightTrackPaint,
    ) = switch (textDirection) {
      TextDirection.ltr => (activePaint, inactivePaint),
      TextDirection.rtl => (inactivePaint, activePaint),
    };

    final trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final trackRadius = Radius.circular(trackRect.height / 2);
    final activeTrackRadius = Radius.circular((trackRect.height) / 2);
    final isLTR = textDirection == TextDirection.ltr;

    final drawInactiveTrack =
        thumbCenter.dx < (trackRect.right - (trackHeight / 2));
    if (drawInactiveTrack) {
      // Draw the inactive track segment.
      context.canvas.drawRRect(
        RRect.fromLTRBR(
          thumbCenter.dx - (trackHeight / 2),
          trackRect.top,
          trackRect.right,
          trackRect.bottom,
          isLTR ? trackRadius : activeTrackRadius,
        ),
        rightTrackPaint,
      );
    }

    final drawActiveTrack =
        thumbCenter.dx > (trackRect.left + (trackHeight / 2));
    if (drawActiveTrack) {
      // Draw the active track segment.
      context.canvas.drawRRect(
        RRect.fromLTRBR(
          trackRect.left,
          isLTR ? trackRect.top : trackRect.top,
          thumbCenter.dx + (trackHeight / 2),
          isLTR ? trackRect.bottom : trackRect.bottom,
          isLTR ? activeTrackRadius : trackRadius,
        ),
        leftTrackPaint,
      );
    }
  }

  @override
  bool get isRounded => true;
}

class _NoOverlayShape extends SliderComponentShape {
  const _NoOverlayShape();

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.zero;
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {}
}
