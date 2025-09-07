import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_client/ui/home/home_cubit.dart';
import 'package:remote_rift_client/ui/widgets/lifecycle.dart';
import 'package:remote_rift_client/data/models.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<HomeCubit>();
    final state = cubit.state.data;

    return Lifecycle(
      onInit: context.read<HomeCubit>().initialize,
      child: Scaffold(
        appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                switch (state) {
                  null => CircularProgressIndicator(),
                  var value => Text(value.displayName),
                },

                if (state != null) SizedBox(height: 12),

                if (state case PreGame())
                  ElevatedButton(onPressed: cubit.createLobby, child: Text('Create lobby')),

                if (state case Lobby(state: GameLobbyState.idle)) ...[
                  ElevatedButton(onPressed: cubit.searchMatch, child: Text('Search game')),
                  SizedBox(height: 4),
                  TextButton(onPressed: cubit.leaveLobby, child: Text('Leave lobby')),
                ],

                if (state case Lobby(state: GameLobbyState.searching))
                  ElevatedButton(onPressed: cubit.stopMatchSearch, child: Text('Cancel search')),

                if (state case Found(state: GameFoundState.pending)) ...[
                  ElevatedButton(onPressed: cubit.acceptMatch, child: Text('Accept game')),
                  SizedBox(height: 4),
                  TextButton(onPressed: cubit.declineMatch, child: Text('Decline game')),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
