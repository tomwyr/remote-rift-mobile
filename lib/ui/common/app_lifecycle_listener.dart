import 'package:flutter/widgets.dart';

class AppLifecycleListener with WidgetsBindingObserver {
  AppLifecycleListener({required AppLifecycleStateChangeListener listener}) : _listener = listener;

  final AppLifecycleStateChangeListener _listener;

  var _registered = false;
  AppLifecycleState? _previous;

  void register() {
    if (_registered) return;
    WidgetsBinding.instance.addObserver(this);
    _previous = WidgetsBinding.instance.lifecycleState;
    _registered = true;
  }

  void unregister() {
    if (!_registered) return;
    WidgetsBinding.instance.removeObserver(this);
    _previous = null;
    _registered = false;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (_previous) {
      case null:
        _previous = state;
        return;

      case var previous when previous == state:
        return;

      case var previous:
        _previous = state;
        _listener(previous, state);
    }
  }
}

typedef AppLifecycleStateChangeListener =
    void Function(AppLifecycleState from, AppLifecycleState to);
