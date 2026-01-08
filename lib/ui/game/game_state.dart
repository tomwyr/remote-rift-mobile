import 'package:draft/draft.dart';
import 'package:equatable/equatable.dart';

import '../../data/models.dart';

part 'game_state.draft.dart';

sealed class GameState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Loading extends GameState {}

@draft
class Data extends GameState {
  Data({required this.state, this.loading = false});

  final RemoteRiftState state;
  final bool loading;

  @override
  List<Object?> get props => [state, loading];
}
