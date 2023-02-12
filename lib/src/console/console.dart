import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
    _streamSubscription = _outSink.controller.stream.listen(
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

  late final StreamSubscription<List<int>> _streamSubscription;

  void _outSinkListener(List<int> data) {
    _out.add(data);
  }

  void _outSinkErrorListener(Object error, StackTrace stackTrace) {
    _out.addError(error, stackTrace);
  }

  void _outSinkDoneListener() {
    _out.close();
  }
}
