import 'package:advanced_console/advanced_console.dart';

void main() {
  final console = Console();

  console.write(style(
    "Hello world",
    ConsoleTextStyle(
      color: ConsoleColor.red,
      bold: true,
      underline: true,
    ),
  ));
}
