import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/local_storage.dart';
import 'data/remote_rift_api.dart';
import 'ui/connection/connection_cubit.dart';
import 'ui/game/game_cubit.dart';
import 'ui/settings/settings_cubit.dart';

class Dependencies {
  static ConnectionCubit connectionCubit(BuildContext context) =>
      ConnectionCubit(remoteRiftApi: _remoteRiftApi, localStorage: _localStorage);

  static GameCubit gameCubit(BuildContext context) => GameCubit(remoteRiftApi: _remoteRiftApi);

  static SettingsCubit settingsCubit(BuildContext context) =>
      SettingsCubit(localStorage: _localStorage);

  static final _remoteRiftApi = RemoteRiftApi(client: HttpClient());
  static final _localStorage = LocalStorage(sharedPrefs: SharedPreferencesAsync());
}
