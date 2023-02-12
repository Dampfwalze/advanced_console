import 'package:advanced_console/advanced_console.dart';
import 'package:async/async.dart';

void main() async {
  final console = Console();

  console.out.writeln("Hello World");

  await Future.delayed(Duration(milliseconds: 1000));

  final console2 = Console(
    out: console.out,
    err: console.err,
    inp: console.inp,
  );

  console2.out.writeln("Hello World2");
}
