import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_mobile/data/local_storage.dart';
import 'package:remote_rift_mobile/data/models.dart';
import 'package:remote_rift_mobile/data/remote_rift_api.dart';
import 'package:remote_rift_mobile/ui/home/home_state.dart';
import 'package:rxdart/rxdart.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.remoteRiftApi, required this.localStorage}) : super(Initial());

  final RemoteRiftApi remoteRiftApi;
  final LocalStorage localStorage;

  final _cancelGameStateListener = StreamController.broadcast();

  void initialize() {
    if (state is! Initial) {
      throw StateError('Tried to initialize while not in initial state (was ${state.runtimeType})');
    }
    _connectToGameApi();
  }

  void reconnect() {
    if (state is! ConnectionError) {
      throw StateError('Tried to reconnect while not in error state (was ${state.runtimeType})');
    }
    _connectToGameApi();
  }

  void _connectToGameApi() async {
    if (!await localStorage.hasApiAddress()) {
      emit(ConfigurationRequired());
    }
    await for (var apiAddress in localStorage.apiAddressStream) {
      remoteRiftApi.setApiAddress(apiAddress);
      _resetGameStateListener(apiAddress);
    }
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

  void _resetGameStateListener(String apiAddress) {
    _cancelGameStateListener.add(null);
    emit(Connecting());
    if (apiAddress.isNotEmpty) {
      final gameStateStream = remoteRiftApi.getCurrentStateStream().takeUntil(
        _cancelGameStateListener.stream,
      );
      _listenGameState(gameStateStream);
    }
  }

  void _listenGameState(Stream<RemoteRiftState> gameStateStream) async {
    try {
      await for (var gameState in gameStateStream) {
        emit(switch (state) {
          Connecting() => Connected(state: gameState),
          Connected data => data.produce((draft) => draft.state = gameState),
          _ => throw StateError(
            'Tried to emit game state without active connection to the game api (was ${state.runtimeType})',
          ),
        });
      }
    } catch (_) {
      emit(ConnectionError());
    }
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
