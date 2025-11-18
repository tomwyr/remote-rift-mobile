import 'package:json_annotation/json_annotation.dart';

import '../i18n/strings.g.dart';
import '../utils/map_extensions.dart';

part 'models.g.dart';

sealed class RemoteRiftStateResponse {
  factory RemoteRiftStateResponse.fromJson(Map<String, dynamic> json) {
    final type = json['type'];
    return switch (type) {
      'data' => RemoteRiftState.fromJson(json),
      'error' => RemoteRiftStateError.fromJson(json),
      _ => throw ArgumentError('Unexpected RemoteRiftStateResponse type $type'),
    };
  }
}

sealed class RemoteRiftState implements RemoteRiftStateResponse {
  RemoteRiftState();

  factory RemoteRiftState.fromJson(Map<String, dynamic> json) {
    final type = json['value'];
    return switch (type) {
      'preGame' => PreGame(),
      'lobby' => Lobby.fromJson(json),
      'found' => Found.fromJson(json),
      'inGame' => InGame(),
      'unknown' => Unknown(),
      _ => throw ArgumentError('Unexpected RemoteRiftState type $type'),
    };
  }

  String get displayName => switch (this) {
    PreGame() => t.gameState.preGame,
    Lobby(:var state) => switch (state) {
      .idle => t.gameState.lobbyIdle,
      .searching => t.gameState.lobbySearching,
    },
    Found(:var state) => switch (state) {
      .pending => t.gameState.foundPending,
      .accepted => t.gameState.foundAccepted,
      .declined => t.gameState.foundDeclined,
    },
    InGame() => t.gameState.inGame,
    Unknown() => t.gameState.unknown,
  };
}

class PreGame extends RemoteRiftState {}

@JsonSerializable()
class Lobby extends RemoteRiftState {
  Lobby({required this.state});

  final GameLobbyState state;

  factory Lobby.fromJson(Map<String, dynamic> json) => _$LobbyFromJson(json);
}

@JsonSerializable()
class Found extends RemoteRiftState {
  Found({required this.state});

  final GameFoundState state;

  factory Found.fromJson(Map<String, dynamic> json) => _$FoundFromJson(json);
}

class InGame extends RemoteRiftState {}

class Unknown extends RemoteRiftState {}

enum GameLobbyState { idle, searching }

enum GameFoundState { pending, accepted, declined }

@JsonEnum(alwaysCreate: true)
enum RemoteRiftStateError implements RemoteRiftStateResponse {
  unableToConnect,
  unknown;

  factory RemoteRiftStateError.fromJson(Map<String, dynamic> json) {
    final value = json['value'];
    for (var (error, json) in _$RemoteRiftStateErrorEnumMap.records) {
      if (json == value) return error;
    }
    throw ArgumentError('Unexpected RemoteRiftStateError json value $value');
  }

  String get title => switch (this) {
    .unableToConnect => t.gameError.unableToConnectTitle,
    .unknown => t.gameError.unknownTitle,
  };

  String get description => switch (this) {
    .unableToConnect => t.gameError.unableToConnectDescription,
    .unknown => t.gameError.unknownDescription,
  };
}
