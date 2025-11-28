import 'package:cancelable_stream/cancelable_stream.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models.dart';
import '../../data/remote_rift_api.dart';
import 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit({required this.remoteRiftApi}) : super(Loading());

  final RemoteRiftApi remoteRiftApi;

  CancelableStream<RemoteRiftState>? _gameStateStream;

  void initialize() {
    _listenGameStateWithRetry();
  }

  void dispose() {
    _stopGameStateStream();
  }

  void createLobby() {
    _runGameAction(() async {
      await remoteRiftApi.createLobby();
    });
  }

  void searchMatch() {
    _runGameAction(() async {
      await remoteRiftApi.searchMatch();
    });
  }

  void leaveLobby() {
    _runGameAction(() async {
      await remoteRiftApi.leaveLobby();
    });
  }

  void stopMatchSearch() {
    _runGameAction(() async {
      await remoteRiftApi.stopMatchSearch();
    });
  }

  void acceptMatch() {
    _runGameAction(() async {
      await remoteRiftApi.acceptMatch();
    });
  }

  void declineMatch() {
    _runGameAction(() async {
      await remoteRiftApi.declineMatch();
    });
  }

  Future<void> _listenGameStateWithRetry() async {
    try {
      await _listenGameState();
    } catch (_) {
      await Future.delayed(Duration(seconds: 1));
      _listenGameStateWithRetry();
    }
  }

  Future<void> _listenGameState() async {
    final stream = remoteRiftApi.getCurrentStateStream().cancelable();
    _gameStateStream = stream;

    await for (var gameState in stream) {
      emit(switch (state) {
        Data data => data.produce((draft) => draft..gameState = gameState),
        Loading() => Data(gameState: gameState),
      });
    }
  }

  void _stopGameStateStream() {
    _gameStateStream?.cancel();
    _gameStateStream = null;
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
    } finally {
      emit(currentState.produce((draft) => draft.loading = false));
    }
  }
}
