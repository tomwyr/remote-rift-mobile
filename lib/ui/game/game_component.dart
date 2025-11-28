import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models.dart';
import '../../dependencies.dart';
import '../../i18n/strings.g.dart';
import '../widgets/layout.dart';
import '../widgets/lifecycle.dart';
import 'game_cubit.dart';
import 'game_state.dart';

class GameComponent extends StatelessWidget {
  const GameComponent({super.key});

  static Widget builder() {
    return BlocProvider(create: Dependencies.gameCubit, child: GameComponent());
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<GameCubit>();

    return Lifecycle(
      onInit: cubit.initialize,
      onDispose: cubit.dispose,
      child: switch (cubit.state) {
        Loading() => BasicLayout(title: t.connection.loadingState, loading: true),

        Data(gameState: var state, :var loading) => switch (state) {
          PreGame() => BasicLayout(
            title: state.displayName,
            action: .new(
              label: t.home.createLobbyButton,
              onPressed: !loading ? cubit.createLobby : null,
            ),
          ),
          Lobby(state: .idle) => BasicLayout(
            title: state.displayName,
            action: .new(
              label: t.home.searchGameButton,
              onPressed: !loading ? cubit.searchMatch : null,
            ),
            secondaryAction: .new(
              label: t.home.leaveLobbyButton,
              onPressed: !loading ? cubit.leaveLobby : null,
            ),
          ),
          Lobby(state: .searching) => BasicLayout(
            title: state.displayName,
            action: .new(
              label: t.home.cancelSearchButton,
              onPressed: !loading ? cubit.stopMatchSearch : null,
            ),
          ),
          Found(state: .pending) => BasicLayout(
            title: state.displayName,
            action: .new(
              label: t.home.acceptGameButton,
              onPressed: !loading ? cubit.acceptMatch : null,
            ),
            secondaryAction: .new(label: t.home.declineGameButton, onPressed: cubit.declineMatch),
          ),

          Found(state: .accepted || .declined) || InGame() || Unknown() => const SizedBox.shrink(),
        },
      },
    );
  }
}
