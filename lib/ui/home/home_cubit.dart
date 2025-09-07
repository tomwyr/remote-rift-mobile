import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_client/data/remote_rift_api.dart';
import 'package:remote_rift_client/ui/home/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.api}) : super(Initial());

  final RemoteRiftApi api;

  var _initialized = false;

  void initialize() async {
    if (_initialized) return;
    _initialized = true;
    await for (var gameState in api.getCurrentStateStream()) {
      emit(switch (state) {
        Initial() => Data(state: gameState),
        Data data => data.produce((draft) => draft.state = gameState),
      });
    }
  }

  void createLobby() {
    _runAsync(() async {
      await api.createLobby();
    });
  }

  void searchMatch() {
    _runAsync(() async {
      await api.searchMatch();
    });
  }

  void leaveLobby() {
    _runAsync(() async {
      await api.leaveLobby();
    });
  }

  void stopMatchSearch() {
    _runAsync(() async {
      await api.stopMatchSearch();
    });
  }

  void acceptMatch() {
    _runAsync(() async {
      await api.acceptMatch();
    });
  }

  void declineMatch() {
    _runAsync(() async {
      await api.declineMatch();
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
