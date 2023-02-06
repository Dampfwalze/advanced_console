library advanced_console.styling;

import 'package:advanced_console/src/styling/style.dart';

/// Basic ANSI color codes. See https://en.wikipedia.org/wiki/ANSI_escape_code#3/4_bit
///
/// These can be used with [style] to color text.
///
/// Example:
/// ```dart
/// print(style("Hello World", color: ConsoleColor.red));
/// ```
abstract class ConsoleColor {
  static const reset = ConsoleColorBasic._(39);

  static const black = ConsoleColorBasic._(30);
  static const red = ConsoleColorBasic._(31);
  static const green = ConsoleColorBasic._(32);
  static const yellow = ConsoleColorBasic._(33);
  static const blue = ConsoleColorBasic._(34);
  static const magenta = ConsoleColorBasic._(35);
  static const cyan = ConsoleColorBasic._(36);
  static const white = ConsoleColorBasic._(37);

  static const blackBright = ConsoleColorBasic._(90);
  static const redBright = ConsoleColorBasic._(91);
  static const greenBright = ConsoleColorBasic._(92);
  static const yellowBright = ConsoleColorBasic._(93);
  static const blueBright = ConsoleColorBasic._(94);
  static const magentaBright = ConsoleColorBasic._(95);
  static const cyanBright = ConsoleColorBasic._(96);
  static const whiteBright = ConsoleColorBasic._(97);

  const ConsoleColor();
}

class ConsoleColorBasic extends ConsoleColor {
  final int ansiCode;

  int get ansiCodeBackground => ansiCode + 10;

  const ConsoleColorBasic._(this.ansiCode);
}

/// ANSI 256 color codes. See https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit
///
/// Note that these colors may only be supported by a subset of terminals, that would support [ConsoleColor].
///
/// Note that these colors do not support bold text styles.
class ConsoleColor256 extends ConsoleColor {
  static const black = ConsoleColor256(0);
  static const red = ConsoleColor256(1);
  static const green = ConsoleColor256(2);
  static const yellow = ConsoleColor256(3);
  static const blue = ConsoleColor256(4);
  static const magenta = ConsoleColor256(5);
  static const cyan = ConsoleColor256(6);
  static const white = ConsoleColor256(7);

  static const blackBright = ConsoleColor256(8);
  static const redBright = ConsoleColor256(9);
  static const greenBright = ConsoleColor256(10);
  static const yellowBright = ConsoleColor256(11);
  static const blueBright = ConsoleColor256(12);
  static const magentaBright = ConsoleColor256(13);
  static const cyanBright = ConsoleColor256(14);
  static const grayBright = ConsoleColor256(15);

  final int ansiCode;

  const ConsoleColor256(this.ansiCode);

  /// Converts a value between 0 and 1 to a 256 color code in the gray scale range.
  ConsoleColor256.grayScale(double value) : this(_lerpDouble(232, 255, value.clamp(0, 1)).round());
}

/// ANSI 24-bit rgb color codes. See https://en.wikipedia.org/wiki/ANSI_escape_code#24-bit
///
/// Note that these colors may only be supported by a subset of terminals, that would support [ConsoleColor].
///
/// Note that these colors do not support style parameters (like bold).
class ConsoleColorRGB extends ConsoleColor {
  final int r;
  final int g;
  final int b;

  const ConsoleColorRGB._(this.r, this.g, this.b);

  /// When [red], [green] and [blue] are integers, expects them to be in range 0 - 255. Values out of range will be clamped.
  ///
  /// When [red], [green] and [blue] are doubles, expects them to be in range 0 - 1. Values out of range will be clamped.
  ///
  /// Integer and double values can be mixed.
  ///
  /// When [red] is an integer and [green] and [blue] are null, expects [red] to be a rgb color code.
  ///
  /// Examples:
  /// ```dart
  /// final color = ConsoleColorRGB(255, 0, 0); // will interpret as rgb(255, 0, 0)
  /// final color = ConsoleColorRGB(1, 0, 0); // will interpret as rgb(255, 0, 0)
  /// final color = ConsoleColorRGB(0xFF0000); // will interpret as rgb(255, 0, 0)
  /// final color = ConsoleColorRGB(0xFF0000, 0); // not allowed
  /// final color = ConsoleColorRGB(300, 0, 0); // will be clamped to rgb(255, 0, 0)
  /// final color = ConsoleColorRGB(1.5, -1, 0); // will be clamped to rgb(255, 0, 0)
  /// ```
  factory ConsoleColorRGB(num red, num? green, num? blue) {
    if (red is int && (green == null || blue == null)) {
      assert(blue == null && green == null);
      return ConsoleColorRGB._(red >> 16 & 0xFF, red >> 8 & 0xFF, red & 0xFF);
    } else {
      return ConsoleColorRGB._(
        red is int ? red.clamp(0, 255) : (red.clamp(0, 1) * 255).round(),
        green is int ? green.clamp(0, 255) : (red.clamp(0, 1) * 255).round(),
        blue is int ? blue.clamp(0, 255) : (red.clamp(0, 1) * 255).round(),
      );
    }
  }

  /// Converts a value between 0 and 1 to a rgb color code.
  factory ConsoleColorRGB.grayScale(double value) {
    int v = (value.clamp(0, 1) * 255).round();
    return ConsoleColorRGB(v, v, v);
  }
}

double _lerpDouble(double a, double b, double t) => a + (b - a) * t;
