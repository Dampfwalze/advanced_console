import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:advanced_console/src/console/ansi_stream.dart';
import 'package:async/async.dart';

part 'console_sink.dart';

class Console {
  Console({
    Stdout? out,
    Stdout? err,
    Stdin? inp,
  })  : _out = out ?? stdout,
        _err = err ?? stderr,
        _inp = inp ?? stdin {
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

  void _outSinkListener(AnsiSymbol data) {
    final int lineOffset = 3;
    if (data is AnsiCharacter) {
      _out.add([data.codeUnit]);
    } else if (data is AnsiSingleControlCharacter) {
      _out.add([data.codeUnit]);
    } else if (data is AnsiEscape) {
      _out.write(data.sequence);
    }
  }

  void _outSinkErrorListener(Object error, StackTrace stackTrace) {
    _out.addError(error, stackTrace);
  }

  void _outSinkDoneListener() {
    _out.close();
  }
}
