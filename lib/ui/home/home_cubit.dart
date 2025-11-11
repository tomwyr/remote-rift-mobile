import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_mobile/data/local_storage.dart';
import 'package:remote_rift_mobile/data/models.dart';
import 'package:remote_rift_mobile/data/remote_rift_api.dart';
import 'package:remote_rift_mobile/ui/home/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.remoteRiftApi, required this.localStorage}) : super(Initial());

  final RemoteRiftApi remoteRiftApi;
  final LocalStorage localStorage;

  StreamSubscription? _gameStateSubscription;

  var _initialized = false;

  void initialize() async {
    if (_initialized) return;
    _initialized = true;
    await for (var apiAddress in localStorage.apiAddressStream) {
      remoteRiftApi.setApiAddress(apiAddress);
      _resetGameStateListener(apiAddress);
    }
  }

  void createLobby() {
    _runAsync(() async {
      await remoteRiftApi.createLobby();
    });
  }

  void searchMatch() {
    _runAsync(() async {
      await remoteRiftApi.searchMatch();
    });
  }

  void leaveLobby() {
    _runAsync(() async {
      await remoteRiftApi.leaveLobby();
    });
  }

  void stopMatchSearch() {
    _runAsync(() async {
      await remoteRiftApi.stopMatchSearch();
    });
  }

  void acceptMatch() {
    _runAsync(() async {
      await remoteRiftApi.acceptMatch();
    });
  }

  void declineMatch() {
    _runAsync(() async {
      await remoteRiftApi.declineMatch();
    });
  }

  void _resetGameStateListener(String apiAddress) {
    emit(Initial());
    _gameStateSubscription?.cancel();
    if (apiAddress.isNotEmpty) {
      _gameStateSubscription = remoteRiftApi.getCurrentStateStream().listen(_emitGameState);
    }
  }

  void _emitGameState(RemoteRiftState gameState) {
    emit(switch (state) {
      Initial() => Data(state: gameState),
      Data data => data.produce((draft) => draft.state = gameState),
    });
  }

  Future<void> _runAsync(AsyncCallback action) async {
    final currentState = switch (state) {
      Initial() => throw StateError('Unexpected async action in initial state'),
      Data data => data,
    };

    try {
      emit(currentState.produce((draft) => draft.loading = true));
      await action();
    } finally {
      emit(currentState.produce((draft) => draft.loading = false));
    }
  }
}
