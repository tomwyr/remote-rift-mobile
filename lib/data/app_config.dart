class AppConfig {
  AppConfig({required this.apiMinVersion});

  AppConfig.defaults() : apiMinVersion = '0.12.0';

  final String apiMinVersion;
}
