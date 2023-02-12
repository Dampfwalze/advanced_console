// ignore_for_file: constant_identifier_names, non_constant_identifier_names

class AnsiCodes {
  // Subset of C0 controls https://en.wikipedia.org/wiki/C0_and_C1_control_codes#Basic_ASCII_control_codes

  static const String NUL = '\u0000';

  static const String BEL = '\u0007'; // \a (Not supported by Dart)
  static const String BS = '\u0008'; // \b
  static const String HT = '\u0009'; // \t
  static const String LF = '\u000A'; // \n
  static const String VT = '\u000B'; // \v
  static const String FF = '\u000C'; // \f
  static const String CR = '\u000D'; // \r

  static const String ESC = '\u001b'; // \e (Not supported by Dart)

  // Subset of C1 controls https://en.wikipedia.org/wiki/C0_and_C1_control_codes#C1_control_codes_for_general_use

  static const String ESC_SS2 = '${ESC}N';
  static const String ESC_SS3 = '${ESC}O';
  static const String ESC_DCS = '${ESC}P';
  static const String ESC_SOS = '${ESC}X';
  static const String ESC_CSI = '$ESC[';
  static const String ESC_ST = '$ESC\\';
  static const String ESC_OSC = '$ESC]';
  static const String ESC_PM = '$ESC^';
  static const String ESC_APC = '${ESC}_';

  // CSI sequences https://en.wikipedia.org/wiki/ANSI_escape_code#CSI_(Control_Sequence_Introducer)_sequences

  static String CSI_CUU([int n = 1]) => '$ESC_CSI${n}A'; // Cursor Up
  static String CSI_CUD([int n = 1]) => '$ESC_CSI${n}B'; // Cursor Down
  static String CSI_CUF([int n = 1]) => '$ESC_CSI${n}C'; // Cursor Forward
  static String CSI_CUB([int n = 1]) => '$ESC_CSI${n}D'; // Cursor Backward
  static String CSI_CNL([int n = 1]) => '$ESC_CSI${n}E'; // Cursor Next Line
  static String CSI_CPL([int n = 1]) => '$ESC_CSI${n}F'; // Cursor Previous Line
  static String CSI_CHA(int n) => '$ESC_CSI${n}G'; // Cursor Horizontal Absolute
  static String CSI_CUP(int n, int m) => '$ESC_CSI$n;${m}H'; // Cursor Position
  static String CSI_ED(int n) => '$ESC_CSI${n}J'; // Erase in Display
  static String CSI_EL(int n) => '$ESC_CSI${n}K'; // Erase in Line
  static String CSI_IL([int n = 1]) => '$ESC_CSI${n}L'; // Insert Line
  static String CSI_DL([int n = 1]) => '$ESC_CSI${n}M'; // Delete Line
  static String CSI_SU([int n = 1]) => '$ESC_CSI${n}S'; // Scroll Up
  static String CSI_SD([int n = 1]) => '$ESC_CSI${n}T'; // Scroll Down
  static String CSI_HVP(int n, int m) =>
      '$ESC_CSI$n;${m}f'; // Horizontal and Vertical Position
  static String CSI_SGR(int n) => '$ESC_CSI${n}m'; // Select Graphic Rendition
  static String CSI_DSR() => '${ESC_CSI}6n'; // Device Status Report

  static final RegExp parseCSI =
      RegExp(r'\x1b\[(?<par>(;*\d+)*)(?<csi>[@[\\\]^_`{|}~A-Za-z])');

  static List<dynamic> parseCSISequence(String sequence) {
    final match = parseCSI.allMatches(sequence).single;
    return [
      match.namedGroup("csi"),
      ...match
          .namedGroup("par")! //
          .split(';')
          .map((e) => e.isEmpty
              ? null
              : int.tryParse(e) ?? (throw Exception("Invalid CSI sequence"))),
    ];
  }
}
