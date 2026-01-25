import 'package:draft/draft.dart';
import 'package:equatable/equatable.dart';
import 'package:remote_rift_core/remote_rift_core.dart';

part 'game_state.draft.dart';

sealed class GameState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Loading extends GameState {}

@draft
class Data extends GameState {
  Data({required this.queueName, required this.state, this.loading = false});

  final String? queueName;
  final RemoteRiftState state;
  final bool loading;

  @override
  List<Object?> get props => [queueName, state, loading];
}
