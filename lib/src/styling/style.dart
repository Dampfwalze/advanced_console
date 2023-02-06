library advanced_console.styling;

import 'package:advanced_console/src/styling/color.dart';
import 'package:advanced_console/src/styling/text_style.dart';

// /// Alias for [style]
// String styleANSI() => style();

/// Apply a [ConsoleTextStyle] to a string.
///
/// Parameters:
/// - [input]: The string to apply the style to.
/// - [style]: The style to apply to the string.
/// - [reset]: Whether to reset the style to the previous style after the string.
///   When colors are reset, they will always be set back to the consoles default color instead of the previous style color. Defaults to `true`.
String style(Object input, [ConsoleTextStyle? style, bool reset = true]) {
  if (style == null) {
    return input.toString();
  }

  String ansiStart = "\u001b[${<int>[
    if (style.color != null) ..._colorToAnsiCode(style.color!),
    if (style.backgroundColor != null)
      ..._colorToAnsiCode(style.backgroundColor!, background: true),
    ...style.parametersToEnable.map((e) => e.ansiCode),
    ...style.parametersToDisable.map((e) => e.ansiResetCode),
  ].join(';')}m";

  String result = ansiStart + input.toString();

  if (reset) {
    String ansiEnd = "\u001b[${<int>[
      if (style.color != null) ConsoleColor.reset.ansiCode,
      if (style.backgroundColor != null) ConsoleColor.reset.ansiCodeBackground,
      ...style.parametersToEnable.map((e) => e.ansiResetCode),
      ...style.parametersToDisable.map((e) => e.ansiCode),
    ].join(';')}m";

    result += ansiEnd;
  }

  return result;
}

List<int> _colorToAnsiCode(ConsoleColor color, {bool background = false}) {
  if (color is ConsoleColorBasic) {
    return [background ? color.ansiCodeBackground : color.ansiCode];
  } else if (color is ConsoleColor256) {
    return [background ? 48 : 38, 5, color.ansiCode];
  } else if (color is ConsoleColorRGB) {
    return [background ? 48 : 38, 2, color.r, color.g, color.b];
  } else {
    throw ArgumentError.value(color, 'color', 'Invalid color');
  }
}
