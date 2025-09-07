import 'package:remote_rift_client/data/models.dart';

class HomeState {
  const HomeState({required this.data});

  const HomeState.initial() : this(data: null);

  final RemoteRiftState? data;
}
