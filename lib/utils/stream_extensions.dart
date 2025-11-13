import 'dart:async';

extension StreamExtensions<T> on Stream<T> {
  /// Pipes this stream into a controller that caches past events and can be closed manually.
  StreamController<T> pipeToController({bool broadcast = true}) {
    final buffer = <T>[];
    final controller = broadcast ? StreamController<T>.broadcast() : StreamController<T>();

    final subscription = listen(
      (event) {
        buffer.add(event);
        if (!controller.isClosed) controller.add(event);
      },
      onError: (e, st) {
        if (!controller.isClosed) controller.addError(e, st);
      },
      onDone: () {
        if (!controller.isClosed) controller.close();
      },
    );

    controller.onListen = () {
      for (final event in buffer) {
        if (!controller.isClosed) controller.add(event);
      }
    };

    controller.onCancel = () => subscription.cancel();

    return controller;
  }
}
