import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/local_storage.dart';
import '../../data/models.dart';
import '../../data/remote_rift_api.dart';
import '../../utils/retry_scheduler.dart';
import '../../utils/stream_extensions.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.remoteRiftApi, required this.localStorage}) : super(Initial());

  final RemoteRiftApi remoteRiftApi;
  final LocalStorage localStorage;

  StreamController<RemoteRiftState>? _gameStateListener;
  RetryScheduler? _reconnectScheduler;

  void initialize() {
    if (state is! Initial) {
      throw StateError('Tried to initialize while not in initial state (was ${state.runtimeType})');
    }
    _connectToGameApi();
  }

  void reconnect() {
    final connectionError = switch (state) {
      ConnectionError state => state,
      _ => throw StateError(
        'Tried to reconnect while not in error state (was ${state.runtimeType})',
      ),
    };

    final scheduler = _reconnectScheduler;
    if (scheduler == null || scheduler.status == .idle) {
      throw StateError('Reconnect scheduler was not running while in connection erro state');
    }

    emit(connectionError.produce((draft) => draft.reconnectTriggered = true));
    scheduler.trigger();
  }

  Future<void> _reconnectToGameApi() async {
    final apiAddress = await localStorage.getApiAddress();
    if (apiAddress case null || '') {
      _onApiAddressMissing();
      return;
    }

    final completer = Completer<void>();
    _resetGameStateListener(apiAddress, onAttemptDone: completer.complete);
    return completer.future;
  }

  void _connectToGameApi() async {
    await for (var apiAddress in localStorage.apiAddressStream) {
      remoteRiftApi.setApiAddress(apiAddress);
      if (apiAddress case null || '') {
        _onApiAddressMissing();
      } else {
        emit(Connecting());
        _resetGameStateListener(apiAddress);
      }
    }
  }

  void _onApiAddressMissing() {
    emit(ConfigurationRequired());
    _gameStateListener?.close();
    _reconnectScheduler?.reset();
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

  void _resetGameStateListener(String apiAddress, {VoidCallback? onAttemptDone}) {
    final listener = remoteRiftApi.getCurrentStateStream().pipeToController();
    _gameStateListener?.close();
    _gameStateListener = listener;
    if (onAttemptDone != null) {
      listener.stream.first.whenComplete(onAttemptDone);
    }
    _listenGameState(listener.stream);
  }

  void _listenGameState(Stream<RemoteRiftState> gameStateStream) async {
    try {
      await for (var gameState in gameStateStream) {
        if (state is ConnectionError) {
          _reconnectScheduler?.reset();
        }
        emit(switch (state) {
          Connecting() || ConnectionError() => Connected(state: gameState),
          Connected connected => connected.produce((draft) => draft.state = gameState),
          _ => throw StateError(
            'Tried to emit game state without active connection to the game api (was ${state.runtimeType})',
          ),
        });
      }
    } catch (_) {
      if (state is! ConnectionError) {
        _reconnectScheduler = _createReconnectScheduler()..start();
      }
      emit(ConnectionError());
    }
  }

  RetryScheduler _createReconnectScheduler() {
    return RetryScheduler(
      startDelay: Duration(seconds: 1),
      maxDelay: Duration(seconds: 5),
      delayStep: Duration(seconds: 1),
      onRetry: _reconnectToGameApi,
    );
  }

  Future<void> _runGameAction(AsyncCallback action) async {
    final currentState = switch (state) {
      Connected data => data,
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
