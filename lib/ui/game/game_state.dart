import 'package:draft/draft.dart';

import '../../data/models.dart';

part 'game_state.draft.dart';

sealed class GameState {}

class Loading extends GameState {}

@draft
class Data extends GameState {
  Data({required this.state, this.loading = false});

  final RemoteRiftState state;
  final bool loading;
}
