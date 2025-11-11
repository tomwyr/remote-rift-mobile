import 'dart:io';

import 'package:flutter/material.dart';
import 'package:remote_rift_mobile/data/local_storage.dart';
import 'package:remote_rift_mobile/data/remote_rift_api.dart';
import 'package:remote_rift_mobile/ui/home/home_cubit.dart';
import 'package:remote_rift_mobile/ui/settings/settings_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dependencies {
  static HomeCubit homeCubit(BuildContext context) => HomeCubit(
    remoteRiftApi: RemoteRiftApi(client: HttpClient()),
    localStorage: _localStorage,
  );

  static SettingsCubit settingsCubit(BuildContext context) =>
      SettingsCubit(localStorage: _localStorage);

  static final _localStorage = LocalStorage(sharedPrefs: SharedPreferencesAsync());
}
