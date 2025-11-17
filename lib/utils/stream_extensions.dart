import 'dart:async';

import 'package:flutter/foundation.dart';

extension StreamExtensions<T> on Stream<T> {
  Stream<T> peek({VoidCallback? onFirstOrError, VoidCallback? onDone}) {
    var firstOrErrorCalled = false;
    handleFirstOrError() {
      if (!firstOrErrorCalled) {
        firstOrErrorCalled = true;
        onFirstOrError?.call();
      }
    }

    return transform(
      .fromHandlers(
        handleData: (data, sink) {
          handleFirstOrError();
          sink.add(data);
        },
        handleError: (error, stackTrace, sink) {
          handleFirstOrError();
          sink.addError(error, stackTrace);
        },
        handleDone: (sink) {
          onDone?.call();
          sink.close();
        },
      ),
    );
  }
}
