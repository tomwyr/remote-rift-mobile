import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/local_storage.dart';
import 'data/remote_rift_api.dart';
import 'ui/home/home_cubit.dart';
import 'ui/settings/settings_cubit.dart';

class Dependencies {
  static HomeCubit homeCubit(BuildContext context) => HomeCubit(
    remoteRiftApi: RemoteRiftApi(client: HttpClient()),
    localStorage: _localStorage,
  );

  static SettingsCubit settingsCubit(BuildContext context) =>
      SettingsCubit(localStorage: _localStorage);

  static final _localStorage = LocalStorage(sharedPrefs: SharedPreferencesAsync());
}
