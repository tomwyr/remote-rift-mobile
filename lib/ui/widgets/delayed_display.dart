import 'dart:async';

import 'package:flutter/material.dart';

class DelayedDisplay extends StatefulWidget {
  const DelayedDisplay({
    super.key,
    required this.delay,
    this.placeholder = const SizedBox.shrink(),
    required this.child,
  });

  final Duration delay;
  final Widget placeholder;
  final Widget child;

  @override
  State<DelayedDisplay> createState() => _DelayedDisplayState();
}

class _DelayedDisplayState extends State<DelayedDisplay> {
  var _isDelayOver = false;

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  void _startDelay() async {
    await Future.delayed(widget.delay);
    if (mounted) {
      setState(() => _isDelayOver = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isDelayOver ? widget.child : widget.placeholder;
  }
}
