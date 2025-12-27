import 'package:flutter/material.dart';

class LiquidMetalLogoState extends ChangeNotifier {
  LiquidMetalLogoState()
    : _type = LiquidMetalLogoType.flutter,
      _background = LiquidMetalLogoBackground.metal;

  LiquidMetalLogoType _type;

  LiquidMetalLogoBackground _background;

  LiquidMetalLogoType get type => _type;

  set type(LiquidMetalLogoType value) {
    if (value == _type) {
      return;
    }

    _type = value;
    notifyListeners();
  }

  LiquidMetalLogoBackground get background => _background;

  set background(LiquidMetalLogoBackground value) {
    if (value == _background) {
      return;
    }

    _background = value;
    notifyListeners();
  }
}

enum LiquidMetalLogoType {
  flutter,
  google,
  apple,
  firebase,
  gemini;

  String get asset {
    return switch (this) {
      flutter => 'assets/images/flutter.png',
      google => 'assets/images/google.png',
      apple => 'assets/images/apple.png',
      firebase => 'assets/images/firebase.png',
      gemini => 'assets/images/gemini.png',
    };
  }

  String get icon {
    return switch (this) {
      flutter => 'assets/images/svg/flutter.svg',
      google => 'assets/images/svg/google.svg',
      apple => 'assets/images/svg/apple.svg',
      firebase => 'assets/images/svg/firebase.svg',
      gemini => 'assets/images/svg/gemini.svg',
    };
  }

  String get label {
    return switch (this) {
      flutter => 'Flutter',
      google => 'Google',
      apple => 'Apple',
      firebase => 'Firebase',
      gemini => 'Gemini',
    };
  }
}

enum LiquidMetalLogoBackground {
  metal,
  white,
  black;

  LinearGradient get gradient {
    final colors = switch (this) {
      metal => const [Color(0xFFEEEEEE), Color(0xFFB8B8B8)],
      white => [Colors.white, Colors.white],
      black => [Colors.black, Colors.black],
    };

    return LinearGradient(
      colors: colors,
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }
}
