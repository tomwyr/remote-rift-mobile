import 'package:flutter/widgets.dart';

class Lifecycle extends StatefulWidget {
  const Lifecycle({super.key, required this.child, this.onInit, this.onDispose});

  final Widget child;
  final VoidCallback? onInit;
  final VoidCallback? onDispose;

  @override
  State<Lifecycle> createState() => _LifecycleState();
}

class _LifecycleState extends State<Lifecycle> {
  @override
  void initState() {
    super.initState();
    widget.onInit?.call();
  }

  @override
  void dispose() {
    widget.onDispose?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
