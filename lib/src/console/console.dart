import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:advanced_console/src/console/ansi_stream.dart';
import 'package:advanced_console/src/console/console_writer.dart';
import 'package:async/async.dart';

part 'console_sink.dart';

class Console {
  Console({
    Stdout? out,
    Stdout? err,
    Stdin? inp,
  })  : _out = out ?? stdout,
        _err = err ?? stderr,
        _inp = inp ?? stdin,
        _writer = ConsoleWriter() {
    _outSink = _ConsoleSink(this);
    _streamSubscription =
        _outSink.controller.stream.transform(AnsiStreamParser()).listen(
              _outSinkListener,
              onError: _outSinkErrorListener,
              onDone: _outSinkDoneListener,
            );
  }

  final Stdout _out;
  final Stdout _err;
  final Stdin _inp;

  late final _ConsoleSink _outSink;

  Stdout get out => _outSink;
  Stdout get err => _err;
  Stdin get inp => _inp;

  late final StreamSubscription<AnsiSymbol> _streamSubscription;

  final ConsoleWriter _writer;

  void _outSinkListener(AnsiSymbol data) {
    _writer.write(data, _out);
  }

  void _outSinkErrorListener(Object error, StackTrace stackTrace) {
    _out.addError(error, stackTrace);
  }

  void _outSinkDoneListener() {
    _out.close();
  }
}
