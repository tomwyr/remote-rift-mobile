import 'package:json_annotation/json_annotation.dart';

import '../i18n/strings.g.dart';

part 'models.g.dart';

@JsonEnum(alwaysCreate: true)
enum RemoteRiftStatus {
  ready,
  unavailable;

  factory RemoteRiftStatus.fromJson(Map<String, dynamic> json) {
    return $enumDecode(_$RemoteRiftStatusEnumMap, json['value']);
  }
}

typedef RemoteRiftStatusResponse = RemoteRiftResponse<RemoteRiftStatus>;

sealed class RemoteRiftState {
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

sealed class RemoteRiftResponse<T> {
  RemoteRiftResponse();

  factory RemoteRiftResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) dataFromJson,
  ) {
    final type = json['type'];
    return switch (type) {
      'data' => RemoteRiftData(dataFromJson(json)),
      'error' => RemoteRiftError.fromJson(json),
      _ => throw ArgumentError('Unexpected RemoteRiftResponse type $type'),
    };
  }
}

class RemoteRiftData<T> extends RemoteRiftResponse<T> {
  RemoteRiftData(this.value);

  final T value;
}

@JsonEnum(alwaysCreate: true)
enum RemoteRiftError<T extends Never> implements RemoteRiftResponse<T> {
  unableToConnect,
  unknown;

  factory RemoteRiftError.fromJson(Map<String, dynamic> json) {
    return $enumDecode(_$RemoteRiftErrorEnumMap, json['value']);
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
