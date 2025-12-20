import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models.dart';
import '../../dependencies.dart';
import '../../i18n/strings.g.dart';
import '../common/utils.dart';
import '../widgets/bloc_listener.dart';
import '../widgets/delayed_display.dart';
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

    return BlocTransitionListener(
      bloc: cubit,
      listener: _vibrateOnStateChange,
      child: Lifecycle(
        onInit: cubit.initialize,
        onDispose: cubit.dispose,
        child: switch (cubit.state) {
          // Delay showing content to avoid flicker when loading appears for a single frame
          Loading() => DelayedDisplay(
            delay: Duration(milliseconds: 200),
            placeholder: BasicLayout(loading: true),
            child: BasicLayout(
              title: t.connection.loadingTitle,
              description: t.connection.loadingDescription,
              loading: true,
            ),
          ),

          Data(state: var state, :var loading) => switch (state) {
            PreGame() => BasicLayout(
              title: t.gameState.preGameTitle,
              description: t.gameState.preGameDescription,
              action: .new(
                label: t.home.createLobbyButton,
                onPressed: !loading ? cubit.createLobby : null,
              ),
            ),

            Lobby(state: .idle) => BasicLayout(
              title: t.gameState.lobbyIdleTitle,
              description: t.gameState.lobbyIdleDescription,
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
              title: t.gameState.lobbySearchingTitle,
              description: t.gameState.lobbySearchingDescription,
              action: .new(
                label: t.home.cancelSearchButton,
                onPressed: !loading ? cubit.stopMatchSearch : null,
              ),
            ),

            Found(state: .pending) => BasicLayout(
              title: t.gameState.foundPendingTitle,
              description: t.gameState.foundPendingDescription,
              action: .new(
                label: t.home.acceptGameButton,
                onPressed: !loading ? cubit.acceptMatch : null,
              ),
              secondaryAction: .new(label: t.home.declineGameButton, onPressed: cubit.declineMatch),
            ),

            Found(state: .accepted) => BasicLayout(
              title: t.gameState.foundAcceptedTitle,
              description: t.gameState.foundAcceptedDescription,
              loading: true,
            ),

            Found(state: .declined) => BasicLayout(
              title: t.gameState.foundDeclinedTitle,
              description: t.gameState.foundDeclinedDescription,
              loading: true,
            ),

            InGame() => BasicLayout(
              title: t.gameState.inGameTitle,
              description: t.gameState.inGameDescription,
            ),

            Unknown() => BasicLayout(
              title: t.gameState.unknownTitle,
              description: t.gameState.unknownDescription,
            ),
          },
        },
      ),
    );
  }

  void _vibrateOnStateChange(GameState previous, GameState current) {
    bool stateMatches<T extends RemoteRiftState>(
      GameState gameState,
      bool Function(T value)? predicate,
    ) {
      if (gameState case Data(:T state)) {
        if (predicate == null || predicate(state)) {
          return true;
        }
      }
      return false;
    }

    bool changedTo<T extends RemoteRiftState>({bool Function(T value)? matching}) {
      return !stateMatches(previous, matching) && stateMatches(current, matching);
    }

    if (changedTo<Lobby>(matching: (value) => value.state == .searching) || changedTo<InGame>()) {
      vibrateMillis(100);
    } else if (changedTo<Unknown>()) {
      vibrateMillis(300);
    } else if (changedTo<Found>(matching: (value) => value.state == .pending)) {
      vibrateMillis(700);
    }
  }
}
