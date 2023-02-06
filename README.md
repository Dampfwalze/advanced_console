Advanced console features for Dart.

> With version 0.0.1, only ANSI text styling is supported.

## Features

- [SGR parameters](https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_(Select_Graphic_Rendition)_parameters) (like: bold, italic, etc.),
- [3-bit and 4-bit colors](https://en.wikipedia.org/wiki/ANSI_escape_code#3-bit_and_4-bit) (With `ConsoleColor`),
- [8-bit colors](https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit) (With `ConsoleColor256`),
- [24-bit rgb colors](https://en.wikipedia.org/wiki/ANSI_escape_code#24-bit) (With `ConsoleColorRGB`),

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

Use the `style` function to apply styles to text:
```dart
print(style("Hello World", ConsoleTextStyle(color: ConsoleColor.yellow, bold: true)));
```

Or use one of the many shortcuts:
```dart
print(red("I have a sunburn"));
print(bold("I'm fat"));
print(italic("I might tip over"));
```

## Additional information

This package is work in progress, but you are welcome to leave your feedback!
