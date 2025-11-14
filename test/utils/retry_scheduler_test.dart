import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remote_rift_mobile/utils/retry_scheduler.dart';

void main() {
  test('throws when created with invalid input', () {
    schedulerWithLowerMaxDelay() => _createScheduler(startDelaySeconds: 2, maxDelaySeconds: 1);
    schedulerWithHigherMaxDelay() => _createScheduler(startDelaySeconds: 1, maxDelaySeconds: 2);
    schedulerWithEqualMaxDelay() => _createScheduler(startDelaySeconds: 1, maxDelaySeconds: 1);

    expect(schedulerWithLowerMaxDelay, throwsAssertionError);
    expect(schedulerWithHigherMaxDelay, returnsNormally);
    expect(schedulerWithEqualMaxDelay, returnsNormally);
  });

  test(
    'changes status correctly during its lifecycle',
    () => fakeAsync((async) {
      final retryCompleter = Completer<void>();
      final scheduler = _createScheduler(
        startDelaySeconds: 2,
        onRetry: () => retryCompleter.future,
      );

      expectStatus(RetrySchedulerStatus status) {
        expect(scheduler.status, status);
      }

      expectStatus(.idle);

      scheduler.start();
      expectStatus(.pending);

      async.elapse(Duration(seconds: 1));
      expectStatus(.pending);

      async.elapse(Duration(seconds: 1));
      expectStatus(.running);

      async.elapse(Duration(seconds: 1));
      expectStatus(.running);

      retryCompleter.complete();
      async.flushMicrotasks();
      expectStatus(.pending);

      scheduler.reset();
      expectStatus(.idle);
    }),
  );

  test(
    'increases delay of consecutive retries by declared step',
    () => fakeAsync((async) {
      var retries = 0;

      final scheduler = _createScheduler(
        startDelaySeconds: 2,
        delayStepSeconds: 1,
        onRetry: () async => retries++,
      );

      scheduler.start();
      addTearDown(scheduler.reset);

      // 1 second total.
      async.elapse(Duration(seconds: 1));
      expect(retries, 0);

      // 2 seconds total.
      async.elapse(Duration(seconds: 1));
      expect(retries, 1);

      // 4 seconds total.
      async.elapse(Duration(seconds: 2));
      expect(retries, 1);

      // 5 seconds total.
      async.elapse(Duration(seconds: 1));
      expect(retries, 2);

      // 8 seconds total.
      async.elapse(Duration(seconds: 3));
      expect(retries, 2);

      // 9 seconds total.
      async.elapse(Duration(seconds: 1));
      expect(retries, 3);
    }),
  );

  test(
    'stops retries when reset',
    () => fakeAsync((async) {
      var retries = 0;

      final scheduler = _createScheduler(
        startDelaySeconds: 2,
        delayStepSeconds: 1,
        onRetry: () async => retries++,
      );

      scheduler.start();

      // 1 second total.
      async.elapse(Duration(seconds: 1));
      expect(retries, 0);

      // 2 seconds total.
      async.elapse(Duration(seconds: 1));
      expect(retries, 1);

      // 4 seconds total.
      async.elapse(Duration(seconds: 2));
      expect(retries, 1);

      scheduler.reset();

      // 5 seconds total.
      async.elapse(Duration(seconds: 1));
      expect(retries, 1);

      // 8 seconds total.
      async.elapse(Duration(seconds: 3));
      expect(retries, 1);

      // 9 seconds total.
      async.elapse(Duration(seconds: 1));
      expect(retries, 1);
    }),
  );

  test(
    'retries instantly when triggered',
    () => fakeAsync((async) {
      var retries = 0;

      final scheduler = _createScheduler(
        startDelaySeconds: 2,
        delayStepSeconds: 1,
        onRetry: () async => retries++,
      );

      scheduler.start();
      addTearDown(scheduler.reset);

      scheduler.trigger();
      async.flushMicrotasks();
      scheduler.trigger();
      async.flushMicrotasks();
      scheduler.trigger();
      async.flushMicrotasks();

      expect(retries, 3);

      // 2 seconds total.
      async.elapse(Duration(seconds: 2));
      expect(retries, 4);
    }),
  );

  test(
    'runs next retry after current step delay when trigger completes',
    () => fakeAsync((async) {
      var retries = 0;

      final scheduler = _createScheduler(
        startDelaySeconds: 2,
        delayStepSeconds: 2,
        onRetry: () async => retries++,
      );

      scheduler.start();
      addTearDown(scheduler.reset);

      // 2 second total.
      async.elapse(Duration(seconds: 2));
      expect(retries, 1);

      // 4 seconds total.
      async.elapse(Duration(seconds: 2));
      scheduler.trigger();
      async.flushMicrotasks();
      expect(retries, 2);

      // 6 seconds total.
      async.elapse(Duration(seconds: 2));
      expect(retries, 2);

      // 8 seconds total.
      async.elapse(Duration(seconds: 2));
      expect(retries, 3);
    }),
  );

  test(
    'does not increase delay step when triggered',
    () => fakeAsync((async) {
      //
    }),
  );
}

RetryScheduler _createScheduler({
  int startDelaySeconds = 0,
  int? maxDelaySeconds,
  int delayStepSeconds = 0,
  AsyncCallback? onRetry,
}) {
  return RetryScheduler(
    startDelay: Duration(seconds: startDelaySeconds),
    maxDelay: maxDelaySeconds != null ? Duration(seconds: maxDelaySeconds) : null,
    delayStep: Duration(seconds: delayStepSeconds),
    onRetry: onRetry ?? () async {},
  );
}
