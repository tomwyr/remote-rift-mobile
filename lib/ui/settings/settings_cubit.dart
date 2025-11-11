import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_mobile/data/local_storage.dart';

import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({required this.localStorage}) : super(Initial());

  final LocalStorage localStorage;

  void initialize() async {
    if (state is! Initial) return;
    final apiAddress = await localStorage.getApiAddress();
    emit(Data(apiAddress: apiAddress));
  }

  void changeApiAddress(String apiAddress) async {
    final data = _requireDataState();
    await localStorage.setApiAddress(apiAddress);
    emit(data.produce((draft) => draft..apiAddress = apiAddress));
  }

  Data _requireDataState() {
    return switch (state) {
      Initial() => throw StateError('Unexpected settings in initial state'),
      Data data => data,
    };
  }
}
