import 'package:draft/draft.dart';

import '../../data/models.dart';

part 'connection_state.draft.dart';

sealed class ConnectionState {}

class Initial extends ConnectionState {}

class ConfigurationRequired extends ConnectionState {}

class Connecting extends ConnectionState {}

class Connected extends ConnectionState {}

class ConnectedWithError extends ConnectionState {
  ConnectedWithError({required this.cause});

  final RemoteRiftError cause;
}

@draft
class ConnectionError extends ConnectionState {
  ConnectionError({this.reconnectTriggered = false});

  final bool reconnectTriggered;
}
