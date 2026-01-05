import 'dart:io';

import 'package:flutter/material.dart';
import 'package:remote_rift_connector_api/remote_rift_connector_api.dart';

import 'data/api_client.dart';
import 'ui/connection/connection_cubit.dart';
import 'ui/game/game_cubit.dart';

class Dependencies {
  static ConnectionCubit connectionCubit(BuildContext context) =>
      ConnectionCubit(apiClient: _apiClient, apiService: _apiService);

  static GameCubit gameCubit(BuildContext context) => GameCubit(apiClient: _apiClient);

  static final _apiClient = RemoteRiftApiClient(client: HttpClient());
  static final _apiService = RemoteRiftApiService();
}
