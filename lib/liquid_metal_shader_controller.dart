import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LiquidMetalShaderController {
  LiquidMetalShaderController.withDefaults({
    required TickerProvider vsync,
  }) : dispersion = LiquidMetalShaderEditableParameter(
         minValue: 0,
         maxValue: 0.06,
         defaultValue: 0.015,
       ),
       edge = LiquidMetalShaderEditableParameter(
         minValue: 0,
         maxValue: 1,
         defaultValue: 0.4,
       ),
       patternBlur = LiquidMetalShaderEditableParameter(
         minValue: 0,
         maxValue: 0.05,
         defaultValue: 0.005,
       ),
       liquid = LiquidMetalShaderEditableParameter(
         minValue: 0,
         maxValue: 1,
         defaultValue: 0.07,
       ),
       patternScale = LiquidMetalShaderEditableParameter(
         minValue: 1,
         maxValue: 10,
         defaultValue: 2,
       ),
       time = LiquidMetalShaderParameter(
         minValue: 0,
         maxValue: double.infinity,
         defaultValue: 0,
       ) {
    speed = LiquidMetalShaderEditableParameter(
      minValue: 0,
      maxValue: 1,
      defaultValue: 0.3,
      onValueChanged: _onSpeedChanged,
    );

    _ticker = vsync.createTicker(_onTick);
  }

  final LiquidMetalShaderEditableParameter dispersion;

  final LiquidMetalShaderEditableParameter edge;

  final LiquidMetalShaderEditableParameter patternBlur;

  final LiquidMetalShaderEditableParameter liquid;

  late final LiquidMetalShaderEditableParameter speed;

  final LiquidMetalShaderEditableParameter patternScale;

  final LiquidMetalShaderParameter time;

  late final Ticker _ticker;

  var _elapsedMilliseconds = 0;

  List<ValueListenable<double>> get parameters => [
    dispersion,
    edge,
    patternBlur,
    liquid,
    speed,
    patternScale,
    time,
  ];

  void dispose() {
    dispersion.dispose();
    edge.dispose();
    patternBlur.dispose();
    liquid.dispose();
    speed.dispose();
    patternScale.dispose();
    time.dispose();

    _ticker.dispose();
  }

  void start() {
    _ticker.start();
  }

  void stop() {
    _ticker.stop();
    _elapsedMilliseconds = 0;
  }

  void _onSpeedChanged(double speed) {
    if (speed == 0) {
      stop();
    } else if (!_ticker.isTicking) {
      start();
    }
  }

  void _onTick(Duration elapsed) {
    final milliseconds = elapsed.inMilliseconds;
    final difference = milliseconds - _elapsedMilliseconds;

    time._value.value += difference * speed.value;

    _elapsedMilliseconds = milliseconds;
  }
}

class LiquidMetalShaderParameter implements ValueListenable<double> {
  LiquidMetalShaderParameter({
    required this.minValue,
    required this.maxValue,
    required double defaultValue,
  }) : assert(
         defaultValue >= minValue && defaultValue <= maxValue,
         'value is not in the allowed range',
       ),
       _value = ValueNotifier(defaultValue);

  final double minValue;

  final double maxValue;

  final ValueNotifier<double> _value;

  @override
  double get value => _value.value;

  void dispose() {
    _value.dispose();
  }

  @override
  void addListener(VoidCallback listener) {
    _value.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _value.removeListener(listener);
  }
}

class LiquidMetalShaderEditableParameter extends LiquidMetalShaderParameter {
  LiquidMetalShaderEditableParameter({
    required super.minValue,
    required super.maxValue,
    required super.defaultValue,
    ValueChanged<double>? onValueChanged,
  }) : _onValueChanged = onValueChanged;

  final ValueChanged<double>? _onValueChanged;

  set value(double newValue) {
    assert(
      newValue >= minValue && newValue <= maxValue,
      'value is not in the allowed range',
    );

    _value.value = newValue;
    _onValueChanged?.call(newValue);
  }
}
