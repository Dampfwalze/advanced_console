/// Support for rich console text styling using ANSI escape codes.
///
/// Use the [style] function to apply styles to text.
/// ```dart
/// print(style("Hello World", ConsoleTextStyle(color: ConsoleColor.red, bold: true)));
/// ```
///
/// This library supports:
/// - [SGR parameters](https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_(Select_Graphic_Rendition)_parameters) (like: bold, italic, etc.),
/// - [3-bit and 4-bit colors](https://en.wikipedia.org/wiki/ANSI_escape_code#3-bit_and_4-bit) (With [ConsoleColor]),
/// - [8-bit colors](https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit) (With [ConsoleColor256]),
/// - [24-bit rgb colors](https://en.wikipedia.org/wiki/ANSI_escape_code#24-bit) (With [ConsoleColorRGB]),
library advanced_console.styling;

import 'package:advanced_console/advanced_console.dart';

export 'src/styling/color.dart';
export 'src/styling/shortcuts.dart';
export 'src/styling/style.dart';
export 'src/styling/text_style.dart';
