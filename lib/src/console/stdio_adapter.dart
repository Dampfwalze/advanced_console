// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'interfaces.dart';

class StdoutAdapter implements ConsoleSink {
  final Stdout _stdout;

  StdoutAdapter([Stdout? _stdout]) : _stdout = _stdout ?? stdout;

  @override
  bool get hasTerminal => _stdout.hasTerminal;

  @override
  int get terminalColumns => _stdout.terminalColumns;

  @override
  int get terminalLines => _stdout.terminalLines;

  @override
  bool get supportsAnsiEscapes => _stdout.supportsAnsiEscapes;

  @override
  void add(List<int> data) => _stdout.add(data);

  @override
  void write(Object? obj) => _stdout.write(obj);

  @override
  void writeAll(Iterable objects, [String separator = ""]) =>
      _stdout.writeAll(objects, separator);

  @override
  void writeln([Object? object = ""]) => _stdout.writeln(object);

  @override
  void writeCharCode(int charCode) => _stdout.writeCharCode(charCode);

  @override
  void addError(Object error, [StackTrace? stackTrace]) =>
      _stdout.addError(error, stackTrace);

  @override
  Future addStream(Stream<List<int>> stream) => _stdout.addStream(stream);

  @override
  Future close() => _stdout.close();

  @override
  Future get done => _stdout.done;

  @override
  Future flush() => _stdout.flush();

  @override
  Encoding get encoding => _stdout.encoding;

  @override
  set encoding(Encoding value) => _stdout.encoding = value;
}

class StdinAdapter extends Stream<List<int>> implements ConsoleSource {
  final Stdin _stdin;

  StdinAdapter([Stdin? _stdin]) : _stdin = _stdin ?? stdin;

  @override
  bool get hasTerminal => _stdin.hasTerminal;

  @override
  bool get echoMode => _stdin.echoMode;

  @override
  set echoMode(bool value) => _stdin.echoMode = value;

  @override
  bool get echoNewlineMode => _stdin.echoNewlineMode;

  @override
  set echoNewlineMode(bool value) => _stdin.echoNewlineMode = value;

  @override
  bool get lineMode => _stdin.lineMode;

  @override
  set lineMode(bool value) => _stdin.lineMode = value;

  @override
  bool get supportsAnsiEscapes => _stdin.supportsAnsiEscapes;

  @override
  int readByteSync() => _stdin.readByteSync();

  @override
  StreamSubscription<List<int>> listen(void Function(List<int> event)? onData,
          {Function? onError, void Function()? onDone, bool? cancelOnError}) =>
      _stdin.listen(onData,
          onError: onError, onDone: onDone, cancelOnError: cancelOnError);
}
