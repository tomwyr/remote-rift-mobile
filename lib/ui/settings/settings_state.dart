import 'package:draft/draft.dart';

part 'settings_state.draft.dart';

sealed class SettingsState {}

class Initial extends SettingsState {}

@draft
class Data extends SettingsState {
  Data({required this.apiAddress});

  final String? apiAddress;
}
