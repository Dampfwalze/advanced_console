import 'dart:io';

abstract class ConsoleSink implements IOSink {
  bool get hasTerminal;

  int get terminalColumns;

  int get terminalLines;

  bool get supportsAnsiEscapes;
}

abstract class ConsoleSource implements Stream<List<int>> {
  bool get echoMode;
  set echoMode(bool value);

  bool get echoNewlineMode;
  set echoNewlineMode(bool value);

  bool get lineMode;
  set lineMode(bool value);

  bool get supportsAnsiEscapes;

  int readByteSync();

  bool get hasTerminal;
}
