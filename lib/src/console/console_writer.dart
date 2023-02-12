import 'dart:io';
import 'dart:math';

import 'package:advanced_console/src/ansi_codes.dart';
import 'package:advanced_console/src/console/ansi_stream.dart';

class _ConsoleWriterBase {
  CursorPosition _cursorPosition;

  final int lineOffset = 5;

  _ConsoleWriterBase(this._cursorPosition);

  void _setCursorPosition(CursorPosition value, Stdout out) {
    value = CursorPosition(
      value.x.clamp(1, out.terminalColumns),
      value.y.clamp(1, out.terminalLines - lineOffset),
    );
    if (value != _cursorPosition) {
      _cursorPosition = value;
      out.write(AnsiCodes.CSI_CUP(_cursorPosition.y, _cursorPosition.x));
    }
  }

  void _horizontalVerticalPosition(CursorPosition value, Stdout out) {
    value = CursorPosition(
      value.x.clamp(1, out.terminalColumns),
      value.y.clamp(1, out.terminalLines - lineOffset),
    );
    if (value != _cursorPosition) {
      _cursorPosition = value;
      out.write(AnsiCodes.CSI_HVP(_cursorPosition.y, _cursorPosition.x));
    }
  }

  void _cursorUp(Stdout out, [int n = 1]) => _setCursorPosition(
        CursorPosition(_cursorPosition.x, _cursorPosition.y - n),
        out,
      );

  void _cursorDown(Stdout out, [int n = 1]) => _setCursorPosition(
        CursorPosition(_cursorPosition.x, _cursorPosition.y + n),
        out,
      );

  void _cursorForward(Stdout out, [int n = 1]) => _setCursorPosition(
        CursorPosition(_cursorPosition.x + n, _cursorPosition.y),
        out,
      );

  void _cursorBackward(Stdout out, [int n = 1]) => _setCursorPosition(
        CursorPosition(_cursorPosition.x - n, _cursorPosition.y),
        out,
      );

  void _cursorNextLine(Stdout out, [int n = 1]) => _setCursorPosition(
        CursorPosition(1, _cursorPosition.y + n),
        out,
      );

  void _cursorPreviousLine(Stdout out, [int n = 1]) => _setCursorPosition(
        CursorPosition(1, _cursorPosition.y - n),
        out,
      );

  void _cursorHorizontalAbsolute(Stdout out, [int n = 1]) => _setCursorPosition(
        CursorPosition(n, _cursorPosition.y),
        out,
      );

  void _eraseInDisplay(Stdout out, [int n = 0]) {
    switch (n) {
      case 0:
        _eraseInLine(out, 0);
        for (var i = _cursorPosition.y + 1;
            i <= out.terminalLines - lineOffset;
            i++) {
          out.write(AnsiCodes.CSI_CUP(i, 1));
          _eraseInLine(out, 0);
        }
        out.write(AnsiCodes.CSI_CUP(
          _cursorPosition.y,
          _cursorPosition.x,
        ));
        break;
      case 1:
        out.write(AnsiCodes.CSI_ED(1));
        break;
      case 2:
        out.write(AnsiCodes.CSI_CUP(
          out.terminalColumns,
          out.terminalLines - lineOffset,
        ));
        out.write(AnsiCodes.CSI_ED(2));
        out.write(AnsiCodes.CSI_CUP(
          _cursorPosition.y,
          _cursorPosition.x,
        ));
        break;
      default:
        throw StateError('Unsupported erase in display mode');
    }
  }

  void _eraseInLine(Stdout out, [int n = 0]) {
    out.write(AnsiCodes.CSI_EL(n));
  }

  void _insertLine(Stdout out, [int n = 1]) {
    out.write(AnsiCodes.CSI_IL(n));
    _cursorPosition = CursorPosition(1, _cursorPosition.y);
  }

  void _deleteLine(Stdout out, [int n = 1]) {
    out.write(AnsiCodes.CSI_DL(n));
    _cursorPosition = CursorPosition(1, _cursorPosition.y);
  }

  void _scrollUp(Stdout out, [int n = 1]) {
    out.write(AnsiCodes.CSI_SU(n));
    final eraseStartLine = max(1, out.terminalLines - lineOffset - n + 1);
    out.write(AnsiCodes.CSI_CUP(eraseStartLine, 1));
    out.write(
        AnsiCodes.CSI_IL(out.terminalLines - lineOffset - eraseStartLine + 1));
    out.write(AnsiCodes.CSI_CUP(_cursorPosition.y, _cursorPosition.x));
  }

  void _scrollDown(Stdout out, [int n = 1]) {
    final eraseStartLine = max(1, out.terminalLines - lineOffset - n + 1);
    out.write(AnsiCodes.CSI_CUP(eraseStartLine, 1));
    out.write(
        AnsiCodes.CSI_DL(out.terminalLines - lineOffset - eraseStartLine + 1));
    out.write(AnsiCodes.CSI_SD(n));
    out.write(AnsiCodes.CSI_CUP(_cursorPosition.y, _cursorPosition.x));
  }

  /// Terminal behavior may be unexpected with \n (does it do carriage return?)
  /// so always do \n\r.
  ///
  /// May have semantic meaning in some terminals
  void _newLine(Stdout out) {
    if (_cursorPosition.y == out.terminalLines - lineOffset) {
      _scrollUp(out);
      _cursorUp(out);
    }
    out.write(AnsiCodes.LF + AnsiCodes.CR); // \n\r
    _cursorPosition = CursorPosition(1, _cursorPosition.y + 1);
  }

  void _writeSingleCharacter(int c, Stdout out) {
    if (_cursorPosition.x == out.terminalColumns + 1) {
      if (_cursorPosition.y == out.terminalLines - lineOffset) {
        _scrollUp(out);
        _cursorHorizontalAbsolute(out);
      } else {
        _cursorPosition = CursorPosition(1, _cursorPosition.y + 1);
      }
    }
    out.writeCharCode(c);
    _cursorPosition = CursorPosition(_cursorPosition.x + 1, _cursorPosition.y);
  }

  /// Terminal behavior may be unexpected with \b (does it go to previous line?)
  /// so implement it ourselves.
  void _backspace(Stdout out) => _setCursorPosition(
        CursorPosition(_cursorPosition.x - 1, _cursorPosition.y),
        out,
      );

  /// Terminal behavior widely undefined with \t and to have custom functionality,
  /// implement it ourselves.
  void _tab(Stdout out) => _setCursorPosition(
        // TODO: implement tab
        CursorPosition(_cursorPosition.x + 8, _cursorPosition.y),
        out,
      );

  void _verticalTab(Stdout out) => _newLine(out);

  /// May have sematic meaning in some terminals, so don't implement it ourselves.
  void _carriageReturn(Stdout out) {
    _cursorPosition = CursorPosition(1, _cursorPosition.y);
    out.write(AnsiCodes.CR);
  }

  void _formFeed(Stdout out) => _newLine(out);
}

class ConsoleWriter extends _ConsoleWriterBase {
  bool _didWriteConsoleLast;

  ConsoleWriter({
    CursorPosition cursorPosition = const CursorPosition(1, 1),
    bool cursorPositionIsCorrect = false,
  })  : _didWriteConsoleLast = cursorPositionIsCorrect,
        super(cursorPosition);

  CursorPosition get cursorPosition => _cursorPosition;

  void invalidateCursorPosition() => _didWriteConsoleLast = false;

  void write(AnsiSymbol c, Stdout out) {
    if (!_didWriteConsoleLast) {
      out.write(AnsiCodes.CSI_CUP(_cursorPosition.y, _cursorPosition.x));
      _didWriteConsoleLast = true;
    }

    if (c is AnsiCharacter) {
      _writeSingleCharacter(c.codeUnit, out);
    } else if (c is AnsiControl) {
      _handleControlCharacter(c, out);
    } else {
      throw StateError('Unsupported character type');
    }
  }

  void _handleControlCharacter(AnsiControl c, Stdout out) {
    if (c is AnsiSingleControlCharacter) {
      _handleSingleControlCharacter(c, out);
    } else if (c is AnsiEscape) {
      _handleEscapeCharacter(c, out);
    } else {
      throw StateError('Unsupported control character type');
    }
  }

  void _handleSingleControlCharacter(AnsiSingleControlCharacter c, Stdout out) {
    switch (String.fromCharCode(c.codeUnit)) {
      case AnsiCodes.BS:
        _backspace(out);
        break;
      case AnsiCodes.HT:
        _tab(out);
        break;
      case AnsiCodes.LF:
        _newLine(out);
        break;
      case AnsiCodes.VT:
        _verticalTab(out);
        break;
      case AnsiCodes.FF:
        _formFeed(out);
        break;
      case AnsiCodes.CR:
        _carriageReturn(out);
        break;
      default:
        out.writeCharCode(c.codeUnit);
    }
  }

  void _handleEscapeCharacter(AnsiEscape c, Stdout out) {
    if (c is AnsiCSI) {
      _handleCSI(c, out);
    } else if (c is AnsiTerminatedEsc) {
      // _handleTerminatedEsc(c, out);
    } else {
      if (c.sequence.length < 2) {
        return;
      }
      final code = c.sequence[1];
      switch (code) {
        case 'D': // IND
          _cursorDown(out);
          break;
        case 'E': // NEL
          _newLine(out);
          break;
        case 'H': // HTS
          // TODO: implement set tab stop
          break;
        case 'I': // HTJ
          // TODO: implement back tab
          break;
        case 'J': // VTS
        // TODO: implement set line tab stop
        case 'K': // PLD
        // TODO: implement PLD
        case 'L': // PLU
        // TODO: implement PLU
        case 'M': // RI
          // TODO: implement RI
          break;
        case 'N': // SS2
        // Obsolete
        case 'O': // SS3
          // Obsolete
          break;
        default:
          out.write(c.sequence);
      }
    }
  }

  void _handleCSI(AnsiCSI c, Stdout out) {
    final res = AnsiCodes.parseCSISequence(c.sequence);
    final String code = res.first;
    final List<int> args = res.sublist(1).cast();

    switch (code) {
      case 'A': // CUU
        _cursorUp(out, args.single);
        break;
      case 'B': // CUD
        _cursorDown(out, args.single);
        break;
      case 'C': // CUF
        _cursorForward(out, args.single);
        break;
      case 'D': // CUB
        _cursorBackward(out, args.single);
        break;
      case 'E': // CNL
        _cursorNextLine(out, args.single);
        break;
      case 'F': // CPL
        _cursorPreviousLine(out, args.single);
        break;
      case 'G': // CHA
        _cursorHorizontalAbsolute(out, args.single);
        break;
      case 'H': // CUP
        int arg1 = 1;
        int arg2 = 1;

        if (args.length == 1) {
          arg2 = args[0];
        } else if (args.length == 2) {
          arg1 = args[1];
          arg2 = args[0];
        } else if (args.length > 2) {
          throw StateError('Too many arguments for CUP');
        }

        _setCursorPosition(CursorPosition(arg1, arg2), out);
        break;
      case 'J': // ED
        _eraseInDisplay(out, args.single);
        break;
      case 'K': // EL
        _eraseInLine(out, args.single);
        break;
      // case 'L': // IL
      //   _insertLines(out, args);
      //   break;
      // case 'M': // DL
      //   _deleteLines(out, args);
      //   break;
      // case 'P': // DCH
      //   _deleteCharacters(out, args);
      //   break;
      case 'S': // SU
        _scrollUp(out, args.single);
        break;
      case 'T': // SD
        _scrollDown(out, args.single);
        break;
      // case 'X': // ECH
      //   _eraseCharacters(out, args);
      //   break;
      // case 'Z': // CBT
      //   _cursorBackwardTabulation(out, args);
      //   break;
      // case '`': // HPA
      //   _cursorHorizontalAbsolute(out, args);
      //   break;
      // case 'a': // HPR
      //   _cursorForward(out, args);
      //   break;
      // case 'b': // REP
      //   _repeatPrecedingCharacter(out, args);
      //   break;
      // case 'c': // DA
      //   _deviceAttributes(out, args);
      //   break;
      // case 'd': // VPA
      //   _cursorVerticalAbsolute(out, args);
      //   break;
      // case 'e': // VPR
      //   _cursorDown(out, args);
      //   break;
      // case 'f': // HVP
    }
  }
}

class CursorPosition {
  const CursorPosition(this.x, this.y);

  final int x;
  final int y;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CursorPosition && x == other.x && y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  String toString() => 'Point($x, $y)';
}
