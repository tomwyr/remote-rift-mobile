import 'package:flutter/material.dart';

import '../../common/duration.dart';

typedef TimeCountdownBuilder = Widget Function(double progress, double seconds);

class TimeCountdown extends StatefulWidget {
  const TimeCountdown({
    super.key,
    required this.start,
    required this.current,
    required this.drift,
    required this.builder,
  }) : assert(
         current >= 0 && start > 0 && current <= start,
         'Current time cannot be negative or exceed start.',
       );

  /// Initial value when the countdown starts.
  final double start;

  /// Current value of the countdown.
  final double current;

  /// The maximum allowed divergence from [current] before the animation
  /// is snapped back to the [current] value.
  final double drift;

  /// Builder for the current countdown state.
  final TimeCountdownBuilder builder;

  @override
  State<TimeCountdown> createState() => _TimeCountdownState();
}

class _TimeCountdownState extends State<TimeCountdown> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  double get _currenProgress => _controller.value;
  double get _currentSeconds => _controller.value * widget.start;

  @override
  void initState() {
    super.initState();
    _controller = _createController();
    _controller.addStatusListener((state) {
      if (state == .dismissed) {
        _controller.duration = DurationFrom.secondsDouble(widget.start);
        _controller.reverse(from: 1);
      }
    });
  }

  @override
  void didUpdateWidget(covariant TimeCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    startChanged() {
      return oldWidget.start != widget.start;
    }

    currentChangeExceedsDrift() {
      if (oldWidget.current != widget.current) {
        final currentDiff = (widget.current - _currentSeconds).abs();
        return currentDiff > widget.drift;
      }
      return false;
    }

    if (startChanged() || currentChangeExceedsDrift()) {
      _controller.dispose();
      _controller = _createController();
    }
  }

  AnimationController _createController() {
    return AnimationController(vsync: this)
      ..duration = DurationFrom.secondsDouble(widget.start)
      ..value = widget.current / widget.start
      ..addListener(() => setState(() {}))
      ..reverse();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_currenProgress, _currentSeconds);
  }
}
