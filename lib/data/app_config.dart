class AppConfig {
  AppConfig({required this.apiMinVersion});

  AppConfig.defaults() : apiMinVersion = '0.11.2';

  final String apiMinVersion;
}
