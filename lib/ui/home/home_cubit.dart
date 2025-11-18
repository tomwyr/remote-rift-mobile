import 'dart:async';

import 'package:cancelable_stream/cancelable_stream.dart';
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

  CancelableStream<RemoteRiftStateResponse>? _gameStateStream;
  RetryScheduler? _reconnectScheduler;

  void initialize() {
    if (state is! Initial) {
      throw StateError('Tried to initialize while not in initial state (was ${state.runtimeType})');
    }
    _initConnectingToGameApi();
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

  void _initConnectingToGameApi() async {
    await for (var apiAddress in localStorage.apiAddressStream) {
      remoteRiftApi.setApiAddress(apiAddress);
      _connectToGameApiAt(apiAddress);
    }
  }

  void _connectToCurrentGameApi() async {
    final apiAddress = await localStorage.getApiAddress();
    _connectToGameApiAt(apiAddress);
  }

  void _connectToGameApiAt(String? apiAddress) {
    if (_verifyApiAddress(apiAddress) case var apiAddress?) {
      emit(Connecting());
      _resetGameStateListener(apiAddress);
    }
  }

  Future<void> _reconnectToGameApi() async {
    final apiAddress = await localStorage.getApiAddress();
    if (_verifyApiAddress(apiAddress) case var apiAddress?) {
      final completer = Completer<void>();
      _resetGameStateListener(apiAddress, onConnectionAttempted: completer.complete);
      await completer.future;
    }
  }

  String? _verifyApiAddress(String? apiAddress) {
    if (apiAddress case null || '') {
      _onApiAddressMissing();
      return null;
    }
    return apiAddress;
  }

  void _onApiAddressMissing() {
    emit(ConfigurationRequired());
    _gameStateStream?.cancel();
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

  void _resetGameStateListener(String apiAddress, {VoidCallback? onConnectionAttempted}) {
    final stream = remoteRiftApi
        .getCurrentStateStream()
        .peek(onFirstOrError: onConnectionAttempted, onDone: _connectToCurrentGameApi)
        .cancelable();
    _gameStateStream?.cancel();
    _gameStateStream = stream;
    _listenGameState(stream);
  }

  void _listenGameState(Stream<RemoteRiftStateResponse> gameStateStream) async {
    try {
      await for (var response in gameStateStream) {
        if (state is ConnectionError) {
          _reconnectScheduler?.reset();
        }

        switch (state) {
          case Connecting() || ConnectedWithError() || ConnectionError() || Connected():
            // Can emit from the current state
            break;
          default:
            throw StateError(
              'Tried to emit game state without active connection to the game api (was ${state.runtimeType})',
            );
        }

        switch (response) {
          case RemoteRiftState gameState:
            emit(switch (state) {
              Connected connected => connected.produce((draft) => draft.state = gameState),
              _ => Connected(state: gameState),
            });

          case RemoteRiftStateError gameError:
            emit(ConnectedWithError(cause: gameError));
        }
      }
    } catch (_) {
      if (state case Connecting() || Connected()) {
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
