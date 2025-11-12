import 'package:draft/draft.dart';

import '../../data/models.dart';

part 'home_state.draft.dart';

sealed class HomeState {}

class Initial extends HomeState {}

class ConfigurationRequired extends HomeState {}

class Connecting extends HomeState {}

@draft
class Connected extends HomeState {
  Connected({required this.state, this.loading = false});

  final RemoteRiftState state;
  final bool loading;
}

class ConnectionError extends HomeState {}
