import 'dart:io';

import 'package:flutter/material.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

import 'data/api_client.dart';
import 'ui/connection/connection_cubit.dart';
import 'ui/game/game_cubit.dart';

class Dependencies {
  static ConnectionCubit connectionCubit(BuildContext context) =>
      ConnectionCubit(apiClient: _apiClient, serviceRegistry: _serviceRegistry);

  static GameCubit gameCubit(BuildContext context) => GameCubit(apiClient: _apiClient);

  static final _apiClient = RemoteRiftApiClient(client: HttpClient());
  static final _serviceRegistry = ServiceRegistry.remoteRift();
}
