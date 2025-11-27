import 'package:draft/draft.dart';

import '../../data/models.dart';

part 'home_state.draft.dart';

sealed class HomeState {}

class Initial extends HomeState {}

class ConfigurationRequired extends HomeState {}

class Connecting extends HomeState {}

@draft
class Connected extends HomeState {
  Connected({this.gameState, this.loading = false});

  final RemoteRiftState? gameState;
  final bool loading;
}

class ConnectedWithError extends HomeState {
  ConnectedWithError({required this.cause});

  final RemoteRiftError cause;
}

@draft
class ConnectionError extends HomeState {
  ConnectionError({this.reconnectTriggered = false});

  final bool reconnectTriggered;
}
