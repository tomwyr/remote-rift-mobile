import 'dart:async';

import 'package:flutter/foundation.dart';

extension CancelableStreamExtension<T> on Stream<T> {
  CancelableStream<T> cancelable() => CancelableStream.from(this);
}

abstract interface class CancelableStream<T> implements Stream<T> {
  factory CancelableStream.from(Stream<T> stream) = _CancelableStream.from;

  Future<void> cancel();
}

class _CancelableStream<T> extends StreamView<T> implements CancelableStream<T> {
  factory _CancelableStream.from(Stream<T> stream) {
    final buffer = <T>[];
    late StreamSubscription<T> subscription;

    final controller = stream.isBroadcast ? StreamController<T>.broadcast() : StreamController<T>();

    controller.onListen = () {
      // Start upstream only when first listener appears
      subscription = stream.listen(
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

      // Replay past events to this new listener
      for (final event in buffer) {
        if (!controller.isClosed) controller.add(event);
      }
    };

    controller.onCancel = () => subscription.cancel();

    return _CancelableStream(controller.stream, () => subscription);
  }

  _CancelableStream(super.stream, this._getSubscription);

  final ValueGetter<StreamSubscription<T>> _getSubscription;

  @override
  Future<void> cancel() => _getSubscription().cancel();
}
