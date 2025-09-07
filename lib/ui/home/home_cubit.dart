import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_client/ui/home/home_state.dart';
import 'package:remote_rift_client/data/remote_rift_api.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.api}) : super(HomeState.initial());

  final RemoteRiftApi api;

  var _initialized = false;

  void initialize() async {
    if (_initialized) return;
    _initialized = true;
    await for (var state in api.getCurrentStateStream()) {
      emit(HomeState(data: state));
    }
  }

  void createLobby() async {
    await api.createLobby();
  }

  void searchMatch() async {
    await api.searchMatch();
  }

  void leaveLobby() async {
    await api.leaveLobby();
  }

  void stopMatchSearch() async {
    await api.stopMatchSearch();
  }

  void acceptMatch() async {
    await api.acceptMatch();
  }

  void declineMatch() async {
    await api.declineMatch();
  }
}
