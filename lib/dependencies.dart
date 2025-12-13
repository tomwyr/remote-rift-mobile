import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/local_storage.dart';
import 'data/api_client.dart';
import 'ui/connection/connection_cubit.dart';
import 'ui/game/game_cubit.dart';
import 'ui/settings/settings_cubit.dart';

class Dependencies {
  static ConnectionCubit connectionCubit(BuildContext context) =>
      ConnectionCubit(apiClient: _remoteRiftApiClient, localStorage: _localStorage);

  static GameCubit gameCubit(BuildContext context) => GameCubit(apiClient: _remoteRiftApiClient);

  static SettingsCubit settingsCubit(BuildContext context) =>
      SettingsCubit(localStorage: _localStorage);

  static final _remoteRiftApiClient = RemoteRiftApiClient(client: HttpClient());
  static final _localStorage = LocalStorage(sharedPrefs: SharedPreferencesAsync());
}
