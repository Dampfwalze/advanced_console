import 'package:advanced_console/advanced_console.dart';

void main() {
  print(style(
    "Hello world",
    ConsoleTextStyle(
      color: ConsoleColor.red,
      bold: true,
      underline: true,
    ),
  ));
}
