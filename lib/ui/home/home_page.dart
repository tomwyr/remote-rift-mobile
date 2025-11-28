import 'package:flutter/material.dart';

import '../../i18n/strings.g.dart';
import '../connection/connection_component.dart';
import '../game/game_component.dart';
import '../settings/settings_drawer.dart';
import '../widgets/drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.app.title),
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [EndDrawerIcon(icon: Icons.tune)],
      ),
      endDrawer: SettingsDrawer.builder(),
      body: Padding(
        padding: const .all(24),
        child: Center(
          child: ConnectionComponent.builder(
            connectedBuilder: (context) => GameComponent.builder(),
          ),
        ),
      ),
    );
  }
}
