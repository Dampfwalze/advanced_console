import 'package:advanced_console/advanced_console.dart';

/// Colors the [input] with the given [color].
///
/// Also see [style] and [red], [green], etc.
String color(ConsoleColor color, Object input,
        {bool background = false, bool reset = true}) =>
    style(
      input,
      ConsoleTextStyle(
        color: color,
        backgroundColor: background ? color : null,
      ),
      reset,
    );

// Colors

/// Colors the [input] black.
///
/// Also see [style].
String black(Object input, {bool background = false, bool reset = true}) =>
    color(ConsoleColor.black, input, background: background, reset: reset);

/// Colors the [input] red.
///
/// Also see [style].
String red(Object input, {bool background = false, bool reset = true}) =>
    color(ConsoleColor.red, input, background: background, reset: reset);

/// Colors the [input] green.
///
/// Also see [style].
String green(Object input, {bool background = false, bool reset = true}) =>
    color(ConsoleColor.green, input, background: background, reset: reset);

/// Colors the [input] yellow.
///
/// Also see [style].
String yellow(Object input, {bool background = false, bool reset = true}) =>
    color(ConsoleColor.yellow, input, background: background, reset: reset);

/// Colors the [input] blue.
///
/// Also see [style].
String blue(Object input, {bool background = false, bool reset = true}) =>
    color(ConsoleColor.blue, input, background: background, reset: reset);

/// Colors the [input] magenta.
///
/// Also see [style].
String magenta(Object input, {bool background = false, bool reset = true}) =>
    color(ConsoleColor.magenta, input, background: background, reset: reset);

/// Colors the [input] cyan.
///
/// Also see [style].
String cyan(Object input, {bool background = false, bool reset = true}) =>
    color(ConsoleColor.cyan, input, background: background, reset: reset);

/// Colors the [input] white.
///
/// Also see [style].
String white(Object input, {bool background = false, bool reset = true}) =>
    color(ConsoleColor.white, input, background: background, reset: reset);

/// Colors the [input] bright black.
///
/// Also see [style].
String blackBright(Object input,
        {bool background = false, bool reset = true}) =>
    color(ConsoleColor.blackBright, input,
        background: background, reset: reset);

/// Colors the [input] bright red.
///
/// Also see [style].
String redBright(Object input, {bool background = false, bool reset = true}) =>
    color(ConsoleColor.redBright, input, background: background, reset: reset);

/// Colors the [input] bright green.
///
/// Also see [style].
String greenBright(Object input,
        {bool background = false, bool reset = true}) =>
    color(ConsoleColor.greenBright, input,
        background: background, reset: reset);

/// Colors the [input] bright yellow.
///
/// Also see [style].
String yellowBright(Object input,
        {bool background = false, bool reset = true}) =>
    color(ConsoleColor.yellowBright, input,
        background: background, reset: reset);

/// Colors the [input] bright blue.
///
/// Also see [style].
String blueBright(Object input, {bool background = false, bool reset = true}) =>
    color(ConsoleColor.blueBright, input, background: background, reset: reset);

/// Colors the [input] bright magenta.
///
/// Also see [style].
String magentaBright(Object input,
        {bool background = false, bool reset = true}) =>
    color(ConsoleColor.magentaBright, input,
        background: background, reset: reset);

/// Colors the [input] bright cyan.
///
/// Also see [style].
String cyanBright(Object input, {bool background = false, bool reset = true}) =>
    color(ConsoleColor.cyanBright, input, background: background, reset: reset);

/// Colors the [input] bright white.
///
/// Also see [style].
String whiteBright(Object input,
        {bool background = false, bool reset = true}) =>
    color(ConsoleColor.whiteBright, input,
        background: background, reset: reset);

// Styles

/// Styles the [input] bold
///
/// Also see [style].
String bold(Object input, {bool reset = true}) =>
    style(input, ConsoleTextStyle(bold: true), reset);

/// Styles the [input] italic
///
/// Also see [style].
String italic(Object input, {bool reset = true}) =>
    style(input, ConsoleTextStyle(italic: true), reset);

/// Styles the [input] underline
///
/// Also see [style].
String underline(Object input, {bool reset = true}) =>
    style(input, ConsoleTextStyle(underline: true), reset);

/// Styles the [input] faint
///
/// Also see [style].
String faint(Object input, {bool reset = true}) =>
    style(input, ConsoleTextStyle(faint: true), reset);

/// Styles the [input] blink
///
/// Also see [style].
String blink(Object input, {bool reset = true}) =>
    style(input, ConsoleTextStyle(blink: true), reset);

/// Styles the [input] blink rapid
///
/// Also see [style].
String blinkRapid(Object input, {bool reset = true}) =>
    style(input, ConsoleTextStyle(blinkRapid: true), reset);

/// Styles the [input] inverse
///
/// Also see [style].
String inverse(Object input, {bool reset = true}) =>
    style(input, ConsoleTextStyle(inverse: true), reset);

/// Styles the [input] hidden
///
/// Also see [style].
String hidden(Object input, {bool reset = true}) =>
    style(input, ConsoleTextStyle(hide: true), reset);

/// Styles the [input] strikeThrough
///
/// Also see [style].
String strikeThrough(Object input, {bool reset = true}) =>
    style(input, ConsoleTextStyle(strikeThrough: true), reset);

/// Styles the [input] overline
///
/// Also see [style].
String overline(Object input, {bool reset = true}) =>
    style(input, ConsoleTextStyle(overline: true), reset);
