import 'package:draft/draft.dart';

import '../../data/models.dart';
import '../../i18n/strings.g.dart';

part 'connection_state.draft.dart';

sealed class ConnectionState {}

class Initial extends ConnectionState {}

class Connecting extends ConnectionState {}

class Connected extends ConnectionState {}

class ConnectedWithError extends ConnectionState {
  ConnectedWithError({required this.cause});

  final RemoteRiftError cause;
}

@draft
class ConnectionError extends ConnectionState {
  ConnectionError({required this.cause, this.reconnectTriggered = false});

  final ConnectionErrorCause cause;
  final bool reconnectTriggered;
}

enum ConnectionErrorCause {
  serviceNotFound,
  unknown;

  String get description => switch (this) {
    .serviceNotFound => t.connection.errorServiceNotFoundDescription,
    .unknown => t.connection.errorUnknownDescription,
  };
}
