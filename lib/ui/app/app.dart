import 'package:flutter/material.dart';
import 'package:remote_rift_foundation_ui/remote_rift_foundation_ui.dart';

import '../../i18n/strings.g.dart';
import '../home/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: t.app.title,
      theme: RemoteRiftTheme.light(),
      builder: RemoteRiftTheme.builder,
      home: const HomePage(),
    );
  }
}
