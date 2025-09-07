import 'package:flutter/material.dart';
import 'package:remote_rift_client/data/remote_rift_api.dart';
import 'package:remote_rift_client/ui/home/home_cubit.dart';

class Dependencies {
  static HomeCubit homeCubit(BuildContext context) => HomeCubit(
    api: RemoteRiftApi.create(
      noSchemeBaseUrl: '192.168.50.252:8080',
      // proxy: 'PROXY 192.168.50.252:9090',
    ),
  );
}
