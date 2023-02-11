import 'dart:convert';

import 'dart:async';

import 'package:advanced_console/src/console/interfaces.dart';

import 'stdio_adapter.dart';

class Console extends _Console implements ConsoleSink, ConsoleSource {
  @override
  final ConsoleSink _sink;
  @override
  final ConsoleSource _source;

  static int _consolesUsingStdin = 0;
  static int _consolesUsingStdout = 0;

  Console({
    ConsoleSink? sink,
    ConsoleSource? source,
  })  : _sink = sink ?? StdoutAdapter(),
        _source = source ?? StdinAdapter(),
        assert(() {
          if (source == null) _consolesUsingStdin++;
          if (sink == null) _consolesUsingStdout++;

          if (_consolesUsingStdin > 1) {
            throw StateError(
              'Only one Console should use stdin at a time. Multiple consoles using stdin can cause unexpected behavior.',
            );
          }
          if (_consolesUsingStdout > 1) {
            throw StateError(
              'Only one Console should use stdout at a time. Multiple consoles using stdout can cause unexpected behavior.',
            );
          }
          return true;
        }());
}

abstract class _Console extends Stream<List<int>>
    implements ConsoleSink, ConsoleSource {
  ConsoleSink get _sink;
  ConsoleSource get _source;

  // ConsoleSink

  @override
  Encoding get encoding => _sink.encoding;

  @override
  set encoding(Encoding value) => _sink.encoding = value;

  @override
  bool get hasTerminal => _sink.hasTerminal;

  @override
  bool get supportsAnsiEscapes => _sink.supportsAnsiEscapes;

  @override
  int get terminalColumns => _sink.terminalColumns;

  @override
  int get terminalLines => _sink.terminalLines;

  @override
  void add(List<int> data) => _sink.add(data);

  @override
  void addError(Object error, [StackTrace? stackTrace]) =>
      _sink.addError(error, stackTrace);

  @override
  Future addStream(Stream<List<int>> stream) => _sink.addStream(stream);

  @override
  Future close() => _sink.close();

  @override
  Future get done => _sink.done;

  @override
  Future flush() => _sink.flush();

  @override
  void write(Object? object) => _sink.write(object);

  @override
  void writeAll(Iterable objects, [String separator = ""]) =>
      _sink.writeAll(objects, separator);

  @override
  void writeCharCode(int charCode) => _sink.writeCharCode(charCode);

  @override
  void writeln([Object? object = ""]) => _sink.writeln(object);

  // ConsoleSource

  @override
  bool get echoMode => _source.echoMode;

  @override
  set echoMode(bool value) => _source.echoMode = value;

  @override
  bool get echoNewlineMode => _source.echoNewlineMode;

  @override
  set echoNewlineMode(bool value) => _source.echoNewlineMode = value;

  @override
  bool get lineMode => _source.lineMode;

  @override
  set lineMode(bool value) => _source.lineMode = value;

  @override
  int readByteSync() => _source.readByteSync();

  @override
  StreamSubscription<List<int>> listen(void Function(List<int> event)? onData,
          {Function? onError, void Function()? onDone, bool? cancelOnError}) =>
      _source.listen(onData,
          onError: onError, onDone: onDone, cancelOnError: cancelOnError);
}
