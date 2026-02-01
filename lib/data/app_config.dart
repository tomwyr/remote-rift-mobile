import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  AppConfig({required this.apiMinVersion});

  AppConfig.fromEnvironment() : apiMinVersion = _readVar('API_MIN_VERSION');

  static Future<void> initialize() async {
    await dotenv.load();
  }

  final String apiMinVersion;
}

String _readVar(String key) {
  if (dotenv.maybeGet(key) case var value?) {
    return value;
  }
  throw ArgumentError('Variable for key $key not set in the environment');
}
