part of 'console.dart';

abstract class _ConsoleSinkBase extends DelegatingStreamSink<List<int>>
    implements Stdout {
  _ConsoleSinkBase(this._parent, this._sink) : super(_sink);

  final IOSink _sink;
  final Console _parent;

  @override
  Encoding get encoding => _sink.encoding;
  @override
  set encoding(Encoding value) => _sink.encoding = value;

  @override
  Future flush() => _sink.flush();

  @override
  // TODO: connect hasTerminal to parent
  bool get hasTerminal => _parent._out.hasTerminal;

  @override
  // TODO: connect nonBlocking to parent
  IOSink get nonBlocking => throw UnimplementedError();

  @override
  // TODO: connect supportsAnsiEscapes to parent
  bool get supportsAnsiEscapes => _parent._out.supportsAnsiEscapes;

  @override
  // TODO: connect terminalColumns to parent
  int get terminalColumns => _parent._out.terminalColumns;

  @override
  // TODO: connect terminalLines to parent
  int get terminalLines => _parent._out.terminalLines;

  @override
  void write(Object? obj) => _sink.write(obj);

  @override
  void writeAll(Iterable objects, [String separator = ""]) =>
      _sink.writeAll(objects, separator);

  @override
  void writeln([Object? object = ""]) => _sink.writeln(object);

  @override
  void writeCharCode(int charCode) => _sink.writeCharCode(charCode);
}

class _ConsoleSink extends _ConsoleSinkBase implements Stdout {
  _ConsoleSink._(super._parent, super._sink, this.controller);

  factory _ConsoleSink(Console parent) {
    final controller = StreamController<List<int>>.broadcast();
    return _ConsoleSink._(
      parent,
      IOSink(controller, encoding: parent._out.encoding),
      controller,
    );
  }

  final StreamController<List<int>> controller;
}
