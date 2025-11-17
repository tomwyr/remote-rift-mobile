import 'dart:async';

import 'package:flutter/foundation.dart';

extension StreamExtensions<T> on Stream<T> {
  Stream<T> peek({VoidCallback? onFirstOrError, VoidCallback? onDone}) {
    var errorOccurred = false;

    var firstOrErrorCalled = false;
    handleFirstOrError() {
      if (!firstOrErrorCalled) {
        firstOrErrorCalled = true;
        onFirstOrError?.call();
      }
    }

    var doneCalled = false;
    handleDone() {
      if (!errorOccurred && !doneCalled) {
        doneCalled = true;
        onDone?.call();
      }
    }

    return transform(
      .fromHandlers(
        handleData: (data, sink) {
          handleFirstOrError();
          sink.add(data);
        },
        handleError: (error, stackTrace, sink) {
          errorOccurred = true;
          handleFirstOrError();
          sink.addError(error, stackTrace);
        },
        handleDone: (sink) {
          handleDone();
          sink.close();
        },
      ),
    );
  }
}
