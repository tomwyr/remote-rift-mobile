import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../dependencies.dart';
import '../i18n/strings.g.dart';
import 'home/home_page.dart';

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
