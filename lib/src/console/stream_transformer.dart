import 'dart:async';

class FlattenTransformer<T> extends StreamTransformerBase<List<T>, T> {
  @override
  Stream<T> bind(Stream<List<T>> stream) {
    late StreamController<T> controller;
    StreamSubscription<List<T>>? subscription;

    void onData(List<T> data) {
      for (final byte in data) {
        controller.add(byte);
      }
    }

    controller = StreamController<T>(
      onListen: () {
        subscription = stream.listen(
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
}
