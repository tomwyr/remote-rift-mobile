import 'dart:async';

import 'package:flutter/foundation.dart';

enum RetrySchedulerStatus { idle, pending, running }

class RetryScheduler {
  RetryScheduler({required this.backoff, required this.onRetry});

  final RetryBackoff backoff;
  final AsyncCallback onRetry;

  RetrySchedulerStatus get status => _status;

  var _status = RetrySchedulerStatus.idle;
  Timer? _timer;

  void start() {
    if (_status == .idle) {
      _scheduleRetry();
    }
  }

  void trigger() {
    if (_status == .pending) {
      _timer?.cancel();
      _runRetry(countAttempt: false);
    }
  }

  void reset() {
    _timer?.cancel();
    _status = .idle;
    backoff.reset();
  }

  void _scheduleRetry() {
    _timer = Timer(backoff.currentDelay(), _runRetry);
    _status = .pending;
  }

  Future<void> _runRetry({bool countAttempt = true}) async {
    _status = .running;
    try {
      await onRetry();
    } finally {
      if (_status != .idle) {
        if (countAttempt) backoff.tick();
        _scheduleRetry();
      }
    }
  }
}

class RetryBackoff {
  RetryBackoff({required this.startDelay, this.maxDelay, required this.delayStep})
    : assert(
        maxDelay == null || maxDelay >= startDelay,
        'Max delay must not be lower than start delay.',
      );

  static final standard = RetryBackoff(
    startDelay: Duration(seconds: 1),
    maxDelay: Duration(seconds: 5),
    delayStep: Duration(seconds: 1),
  );

  final Duration startDelay;
  final Duration? maxDelay;
  final Duration delayStep;

  var _retries = 0;

  Duration tick() {
    _retries++;
    return currentDelay();
  }

  void reset() {
    _retries = 0;
  }

  Duration currentDelay() {
    var delay = startDelay + delayStep * _retries;
    if (maxDelay case var maxDelay?) {
      delay = delay <= maxDelay ? delay : maxDelay;
    }
    return delay;
  }
}
