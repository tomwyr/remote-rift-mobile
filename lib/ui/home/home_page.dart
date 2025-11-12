import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models.dart';
import '../../dependencies.dart';
import '../../i18n/strings.g.dart';
import '../settings/settings_drawer.dart';
import '../widgets/drawer.dart';
import '../widgets/lifecycle.dart';
import 'home_cubit.dart';
import 'home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<HomeCubit>();

    return Lifecycle(
      onInit: context.read<HomeCubit>().initialize,
      child: Scaffold(
        appBar: AppBar(
          title: Text(t.app.title),
          centerTitle: false,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [EndDrawerIcon(icon: Icons.tune)],
        ),
        endDrawer: BlocProvider(create: Dependencies.settingsCubit, child: SettingsDrawer()),
        body: Padding(
          padding: const .all(24),
          child: Center(
            child: Column(
              crossAxisAlignment: .center,
              children: switch (cubit.state) {
                Initial() => [],
                ConfigurationRequired() => [
                  Text(
                    t.connection.configurationRequiredTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 4),
                  Text(t.connection.configurationRequiredDescription),
                ],
                Connecting() => [
                  Text(t.connection.connecting, style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(height: 16),
                  CircularProgressIndicator(),
                ],
                ConnectionError() => [
                  Text(t.connection.errorTitle, style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(height: 4),
                  Text(t.connection.errorDescription),
                  SizedBox(height: 8),
                  ElevatedButton(onPressed: cubit.reconnect, child: Text(t.connection.errorRetry)),
                ],
                Connected(:var state, :var loading) => [
                  Text(state.displayName),
                  SizedBox(height: 12),
                  if (state case PreGame())
                    ElevatedButton(
                      onPressed: !loading ? cubit.createLobby : null,
                      child: Text(t.home.createLobbyButton),
                    ),

                  if (state case Lobby(state: .idle)) ...[
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

                  if (state case Lobby(state: .searching))
                    ElevatedButton(
                      onPressed: !loading ? cubit.stopMatchSearch : null,
                      child: Text(t.home.cancelSearchButton),
                    ),

                  if (state case Found(state: .pending)) ...[
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
