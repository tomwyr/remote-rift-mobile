import 'dart:async';

import 'package:flutter/foundation.dart';

enum RetrySchedulerStatus { idle, pending, running }

class RetryScheduler {
  RetryScheduler({
    required this.startDelay,
    this.maxDelay,
    required this.delayStep,
    required this.onRetry,
  }) : assert(
         maxDelay == null || maxDelay >= startDelay,
         'Max delay must not be lower than start delay.',
       );

  final Duration startDelay;
  final Duration? maxDelay;
  final Duration delayStep;
  final AsyncCallback onRetry;

  RetrySchedulerStatus get status => _status;

  var _status = RetrySchedulerStatus.idle;
  var _attempt = 0;
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
    _attempt = 0;
  }

  void _scheduleRetry() {
    _timer = Timer(_calculateDelay(), _runRetry);
    _status = .pending;
  }

  Duration _calculateDelay() {
    var delay = startDelay + delayStep * _attempt;
    if (maxDelay case var maxDelay?) {
      delay = delay <= maxDelay ? delay : maxDelay;
    }
    return delay;
  }

  Future<void> _runRetry({bool countAttempt = true}) async {
    _status = .running;
    try {
      await onRetry();
    } finally {
      if (_status != .idle) {
        if (countAttempt) _attempt++;
        _scheduleRetry();
      }
    }
  }
}
