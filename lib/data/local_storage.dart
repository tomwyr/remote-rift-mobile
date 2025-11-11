import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage({required this.sharedPrefs});

  final SharedPreferencesAsync sharedPrefs;

  final _apiAddressController = StreamController<String>.broadcast();
  Stream<String> get apiAddressChanges => _apiAddressController.stream;

  Future<String?> getApiAddress() async {
    return sharedPrefs.getString(_keyApiAddress);
  }

  Future<void> setApiAddress(String value) async {
    if (value == await getApiAddress()) return;
    await sharedPrefs.setString(_keyApiAddress, value);
    _apiAddressController.add(value);
  }
}

extension LocalStorageExtensions on LocalStorage {
  Stream<String> get apiAddressStream async* {
    if (await getApiAddress() case var apiAddress?) {
      yield apiAddress;
    }
    yield* apiAddressChanges;
  }
}

const _keyApiAddress = 'RR_API_ADDRESS';
