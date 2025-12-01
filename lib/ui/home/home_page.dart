import 'package:flutter/material.dart';

import '../../i18n/strings.g.dart';
import '../app/app_theme.dart';
import '../common/assets.dart';
import '../connection/connection_component.dart';
import '../game/game_component.dart';
import '../settings/settings_drawer.dart';
import '../widgets/drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsDrawerScope(
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: AppThemeExtension.of(context).appBarLeadingPadding,
            child: Image.asset(Assets.logo),
          ),
          title: Text(t.app.title),
          actions: [EndDrawerIcon(icon: Icons.tune)],
        ),
        endDrawer: SettingsDrawer.builder(),
        body: SafeArea(
          child: Padding(
            padding: .symmetric(horizontal: 24, vertical: 12),
            child: ConnectionComponent.builder(
              connectedBuilder: (context) => GameComponent.builder(),
            ),
          ),
        ),
      ),
    );
  }
}
