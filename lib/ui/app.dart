import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_client/dependencies.dart';
import 'package:remote_rift_client/i18n/strings.g.dart';
import 'package:remote_rift_client/ui/home/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: t.app.title,
      home: BlocProvider(create: Dependencies.homeCubit, child: const HomePage()),
    );
  }
}
