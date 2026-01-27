import 'dart:async';

import 'package:cancelable_stream/cancelable_stream.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_core/remote_rift_core.dart';
import 'package:remote_rift_utils/remote_rift_utils.dart';

import '../../data/api_client.dart';
import 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit({required this.apiClient}) : super(Loading());

  final RemoteRiftApiClient apiClient;

  final _retryBackoff = RetryBackoff.standard;
  CancelableStream<RemoteRiftSession>? _gameSessionStream;
  Timer? _retryTimer;

  void initialize() {
    _listenGameStateWithRetry();
  }

  void dispose() {
    _stopGameStateStream();
  }

  void createLobby({required int queueId}) {
    _runGameAction(() async {
      await apiClient.createLobby(queueId: queueId);
    });
  }

  void searchMatch() {
    _runGameAction(() async {
      await apiClient.searchMatch();
    });
  }

  void leaveLobby() {
    _runGameAction(() async {
      await apiClient.leaveLobby();
    });
  }

  void stopMatchSearch() {
    _runGameAction(() async {
      await apiClient.stopMatchSearch();
    });
  }

  void acceptMatch() {
    _runGameAction(() async {
      await apiClient.acceptMatch();
    });
  }

  void declineMatch() {
    _runGameAction(() async {
      await apiClient.declineMatch();
    });
  }

  Future<void> _listenGameStateWithRetry() async {
    try {
      await _listenGameState();
    } catch (_) {
      _retryTimer = Timer(_retryBackoff.tick(), _listenGameStateWithRetry);
    }
  }

  Future<void> _listenGameState() async {
    final stream = apiClient.getCurrentSessionStream().cancelable();
    _gameSessionStream = stream;

    await for (var gameSession in stream) {
      emit(switch (state) {
        Data data => data.produce(
          (draft) => draft
            ..queueName = gameSession.queueName
            ..state = gameSession.state
            ..loading = false,
        ),
        Loading() => Data(queueName: gameSession.queueName, state: gameSession.state),
      });
    }
  }

  void _stopGameStateStream() {
    _retryTimer?.cancel();
    _retryTimer = null;
    _gameSessionStream?.cancel();
    _gameSessionStream = null;
  }

  Future<void> _runGameAction(AsyncCallback action) async {
    final currentState = switch (state) {
      Data data => data,
      _ => throw StateError(
        'Tried to run game action while not connected to the game api (was ${state.runtimeType})',
      ),
    };

    try {
      emit(currentState.produce((draft) => draft.loading = true));
      await action();
    } catch (_) {
      emit(currentState.produce((draft) => draft.loading = false));
      rethrow;
    }
  }
}
