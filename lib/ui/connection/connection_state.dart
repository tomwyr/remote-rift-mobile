import 'package:draft/draft.dart';
import 'package:equatable/equatable.dart';
import 'package:remote_rift_core/remote_rift_core.dart';

import '../../i18n/strings.g.dart';

part 'connection_state.draft.dart';

sealed class ConnectionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Initial extends ConnectionState {}

class Connecting extends ConnectionState {}

class Connected extends ConnectionState {}

class ConnectedIncompatible extends ConnectionState {
  ConnectedIncompatible({required this.cause});

  final ConnectionIncompatibility cause;

  @override
  List<Object?> get props => [cause];
}

class ConnectedWithError extends ConnectionState {
  ConnectedWithError({required this.cause});

  final RemoteRiftError cause;

  @override
  List<Object?> get props => [cause];
}

@draft
class ConnectionError extends ConnectionState {
  ConnectionError({required this.cause, this.reconnectTriggered = false});

  final ConnectionErrorCause cause;
  final bool reconnectTriggered;

  @override
  List<Object?> get props => [cause, reconnectTriggered];
}

enum ConnectionIncompatibility { apiVersionTooLow }

enum ConnectionErrorCause {
  serviceNotFound,
  connectionLost,
  unknown;

  String get description => switch (this) {
    .serviceNotFound || .connectionLost => t.connection.errorUnableToConnectDescription,
    .unknown => t.connection.errorUnknownDescription,
  };
}
