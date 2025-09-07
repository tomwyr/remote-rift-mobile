import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_client/data/models.dart';
import 'package:remote_rift_client/ui/home/home_cubit.dart';
import 'package:remote_rift_client/ui/home/home_state.dart';
import 'package:remote_rift_client/ui/widgets/lifecycle.dart';

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
                      child: Text('Create lobby'),
                    ),

                  if (state case Lobby(state: GameLobbyState.idle)) ...[
                    ElevatedButton(
                      onPressed: !loading ? cubit.searchMatch : null,
                      child: Text('Search game'),
                    ),
                    SizedBox(height: 4),
                    TextButton(
                      onPressed: !loading ? cubit.leaveLobby : null,
                      child: Text('Leave lobby'),
                    ),
                  ],

                  if (state case Lobby(state: GameLobbyState.searching))
                    ElevatedButton(
                      onPressed: !loading ? cubit.stopMatchSearch : null,
                      child: Text('Cancel search'),
                    ),

                  if (state case Found(state: GameFoundState.pending)) ...[
                    ElevatedButton(
                      onPressed: !loading ? cubit.acceptMatch : null,
                      child: Text('Accept game'),
                    ),
                    SizedBox(height: 4),
                    TextButton(onPressed: cubit.declineMatch, child: Text('Decline game')),
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
