import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_mobile/data/models.dart';
import 'package:remote_rift_mobile/i18n/strings.g.dart';
import 'package:remote_rift_mobile/ui/home/home_cubit.dart';
import 'package:remote_rift_mobile/ui/home/home_state.dart';
import 'package:remote_rift_mobile/ui/widgets/lifecycle.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<HomeCubit>();

    return Lifecycle(
      onInit: context.read<HomeCubit>().initialize,
      child: Scaffold(
        appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: switch (cubit.state) {
                Initial() => [CircularProgressIndicator()],
                Data(:var state, :var loading) => [
                  Text(state.displayName),

                  SizedBox(height: 12),

                  if (state case PreGame())
                    ElevatedButton(
                      onPressed: !loading ? cubit.createLobby : null,
                      child: Text(t.home.createLobbyButton),
                    ),

                  if (state case Lobby(state: GameLobbyState.idle)) ...[
                    ElevatedButton(
                      onPressed: !loading ? cubit.searchMatch : null,
                      child: Text(t.home.searchGameButton),
                    ),
                    SizedBox(height: 4),
                    TextButton(
                      onPressed: !loading ? cubit.leaveLobby : null,
                      child: Text(t.home.leaveLobbyButton),
                    ),
                  ],

                  if (state case Lobby(state: GameLobbyState.searching))
                    ElevatedButton(
                      onPressed: !loading ? cubit.stopMatchSearch : null,
                      child: Text(t.home.cancelSearchButton),
                    ),

                  if (state case Found(state: GameFoundState.pending)) ...[
                    ElevatedButton(
                      onPressed: !loading ? cubit.acceptMatch : null,
                      child: Text(t.home.acceptGameButton),
                    ),
                    SizedBox(height: 4),
                    TextButton(
                      onPressed: cubit.declineMatch,
                      child: Text(t.home.declineGameButton),
                    ),
                  ],
                ],
              },
            ),
          ),
        ),
      ),
    );
  }
}
