library advanced_console.styling;

import 'package:advanced_console/advanced_console.dart';

/// Style to use with the [style] function.
class ConsoleTextStyle {
  ConsoleColor? color;
  ConsoleColor? backgroundColor;
  bool? bold;
  bool? italic;
  bool? underline;
  bool? faint;
  bool? blink;
  bool? blinkRapid;
  bool? inverse;
  bool? hide;
  bool? strikeThrough;
  bool? overline;

  Set<SGRParameter> customEnable;
  Set<SGRParameter> customDisable;

  ConsoleTextStyle({
    this.color,
    this.backgroundColor,
    this.bold,
    this.italic,
    this.underline,
    this.faint,
    this.blink,
    this.blinkRapid,
    this.inverse,
    this.hide,
    this.strikeThrough,
    this.overline,
    this.customEnable = const {},
    this.customDisable = const {},
  });

  Set<SGRParameter> get parametersToEnable => {
        if (bold == true) SGRParameter.bold,
        if (italic == true) SGRParameter.italic,
        if (underline == true) SGRParameter.underline,
        if (faint == true) SGRParameter.faint,
        if (blink == true) SGRParameter.blink,
        if (blinkRapid == true) SGRParameter.blinkRapid,
        if (inverse == true) SGRParameter.inverse,
        if (hide == true) SGRParameter.hide,
        if (strikeThrough == true) SGRParameter.strikeThrough,
        if (overline == true) SGRParameter.overline,
        ...customEnable,
      };

  Set<SGRParameter> get parametersToDisable => {
        if (bold == false) SGRParameter.bold,
        if (italic == false) SGRParameter.italic,
        if (underline == false) SGRParameter.underline,
        if (faint == false) SGRParameter.faint,
        if (blink == false) SGRParameter.blink,
        if (blinkRapid == false) SGRParameter.blinkRapid,
        if (inverse == false) SGRParameter.inverse,
        if (hide == false) SGRParameter.hide,
        if (strikeThrough == false) SGRParameter.strikeThrough,
        if (overline == false) SGRParameter.overline,
        ...customDisable,
      };
}

/// Used by [ConsoleTextStyle].
///
/// Configure custom [SGR parameters](https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_(Select_Graphic_Rendition)_parameters).
///
/// Note that the most sensible parameters are already available in [ConsoleTextStyle].
class SGRParameter {
  static const SGRParameter reset = SGRParameter(0, 0);
  static const SGRParameter bold = SGRParameter(1, 22);
  static const SGRParameter faint = SGRParameter(2, 22);
  static const SGRParameter italic = SGRParameter(3, 23);
  static const SGRParameter underline = SGRParameter(4, 24);
  static const SGRParameter blink = SGRParameter(5, 25);
  static const SGRParameter blinkRapid = SGRParameter(6, 25);
  static const SGRParameter inverse = SGRParameter(7, 27);
  static const SGRParameter hide = SGRParameter(8, 28);
  static const SGRParameter strikeThrough = SGRParameter(9, 29);
  static const SGRParameter overline = SGRParameter(53, 55);

  final int ansiCode;
  final int ansiResetCode;

  const SGRParameter(this.ansiCode, this.ansiResetCode);
}
