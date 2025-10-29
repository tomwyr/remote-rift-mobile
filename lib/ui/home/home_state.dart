import 'package:draft/draft.dart';
import 'package:remote_rift_mobile/data/models.dart';

part 'home_state.draft.dart';

sealed class HomeState {}

class Initial extends HomeState {}

@draft
class Data extends HomeState {
  Data({required this.state, this.loading = false});

  final RemoteRiftState state;
  final bool loading;
}
