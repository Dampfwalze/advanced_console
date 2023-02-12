import 'dart:async';

import 'package:advanced_console/src/ansi_codes.dart';
import 'package:advanced_console/src/console/stream_transformer.dart';

class AnsiStreamParser extends StreamTransformerBase<List<int>, AnsiSymbol> {
  @override
  Stream<AnsiSymbol> bind(Stream<List<int>> stream) {
    late StreamController<AnsiSymbol> controller;
    StreamSubscription<int>? subscription;

    final buffer = StringBuffer();

    var isEscape = false;
    var isCSI = false;
    var isTerminatedEsc = false;

    void onData(int c) {
      if (isEscape) {
        if (isCSI) {
          if (!_isCSIParameterCharacter(c)) {
            buffer.writeCharCode(c);
            controller.add(AnsiCSI(buffer.toString()));
            buffer.clear();
            isEscape = false;
            isCSI = false;
          } else {
            buffer.writeCharCode(c);
          }
          return;
        }
        if (isTerminatedEsc) {
          if (c == r'\'.codeUnitAt(0)) {
            buffer.writeCharCode(c);
            controller.add(AnsiTerminatedEsc(buffer.toString()));
            buffer.clear();
            isEscape = false;
            isTerminatedEsc = false;
          } else {
            buffer.writeCharCode(c);
          }
          return;
        }
        if (c == '['.codeUnitAt(0)) {
          isCSI = true;
        } else if (_isTerminatedEsc(c)) {
          isTerminatedEsc = true;
        } else if (_isLastCharacterInEscapeSequence(c)) {
          buffer.writeCharCode(c);
          controller.add(AnsiEscape(buffer.toString()));
          buffer.clear();
          isEscape = false;
        } else {
          buffer.writeCharCode(c);
        }
        return;
      }
      if (_isC0ControlCharacter(c)) {
        if (c == AnsiCodes.ESC.codeUnitAt(0)) {
          buffer.writeCharCode(c);
          isEscape = true;
        } else {
          controller.add(AnsiSingleControlCharacter(c));
        }
      } else {
        controller.add(AnsiCharacter(c));
      }
    }

    controller = StreamController<AnsiSymbol>(
      onListen: () {
        subscription = stream.transform(FlattenTransformer()).listen(
              onData,
              onError: controller.addError,
              onDone: controller.close,
              cancelOnError: true,
            );
      },
      onPause: () => subscription!.pause(),
      onResume: () => subscription!.resume(),
      onCancel: () => subscription!.cancel(),
    );

    return controller.stream;
  }

  bool _isLastCharacterInEscapeSequence(int c) {
    // @ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_
    return c >= '@'.codeUnitAt(0) && c <= '_'.codeUnitAt(0);
  }

  /// See: https://www.real-world-systems.com/docs/ANSIcode.html#CSI
  bool _isLastCharacterInCSI(int c) {
    // @ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_
    // `abcdefghijklmnopqrstuvwxyz{|}~
    return c >= '@'.codeUnitAt(0) && c <= '~'.codeUnitAt(0);
  }

  /// See: https://www.real-world-systems.com/docs/ANSIcode.html#CSI
  bool _isCSIParameterCharacter(int c) {
    // 0123456789:;<=>?
    return c >= '0'.codeUnitAt(0) && c <= '?'.codeUnitAt(0);
  }

  /// See: https://en.wikipedia.org/wiki/C0_and_C1_control_codes#C0_controls
  bool _isC0ControlCharacter(int c) {
    return c >= 0 && c <= 31;
  }

  bool _isTerminatedEsc(int c) => <int>{
        'P'.codeUnitAt(0),
        'X'.codeUnitAt(0),
        ']'.codeUnitAt(0),
        '^'.codeUnitAt(0),
        '_'.codeUnitAt(0),
      }.contains(c);
}

abstract class AnsiSymbol {
  const AnsiSymbol();
}

class AnsiCharacter extends AnsiSymbol {
  final int codeUnit;

  const AnsiCharacter(this.codeUnit);

  @override
  String toString() => String.fromCharCode(codeUnit);
}

abstract class AnsiControl extends AnsiSymbol {
  const AnsiControl();
}

class AnsiSingleControlCharacter extends AnsiControl {
  final int codeUnit;

  const AnsiSingleControlCharacter(this.codeUnit);

  @override
  String toString() => String.fromCharCode(codeUnit);
}

class AnsiEscape extends AnsiControl {
  final String sequence;

  const AnsiEscape(this.sequence);

  @override
  String toString() => sequence.replaceAll(AnsiCodes.ESC, "^[");
}

class AnsiCSI extends AnsiEscape {
  const AnsiCSI(super.sequence);
}

class AnsiTerminatedEsc extends AnsiEscape {
  const AnsiTerminatedEsc(super.sequence);
}
