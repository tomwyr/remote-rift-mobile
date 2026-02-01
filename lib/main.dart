import 'package:flutter/material.dart';

import 'data/app_config.dart';
import 'ui/app/app.dart';

void main() async {
  await AppConfig.initialize();
  runApp(const App());
}
