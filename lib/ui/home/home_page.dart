import 'package:flutter/material.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

import '../../i18n/strings.g.dart';
import '../common/assets.dart';
import '../connection/connection_component.dart';
import '../game/game_component.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: context.remoteRiftTheme.appBarLeadingPadding,
          child: Image.asset(Assets.logo),
        ),
        title: Text(t.app.title),
      ),
      body: SafeArea(
        child: Padding(
          padding: .symmetric(horizontal: 24, vertical: 12),
          child: ConnectionComponent.builder(
            connectedBuilder: (context) => GameComponent.builder(),
          ),
        ),
      ),
    );
  }
}
