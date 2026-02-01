import 'dart:async';
import 'dart:ui';

import 'package:cancelable_stream/cancelable_stream.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_core/remote_rift_core.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';
import 'package:remote_rift_utils/remote_rift_utils.dart';

import '../../data/api_client.dart';
import '../../data/app_config.dart';
import 'connection_state.dart';

class ConnectionCubit extends Cubit<ConnectionState> {
  ConnectionCubit({required this.appConfig, required this.apiClient, required this.serviceRegistry})
    : super(Initial());

  final AppConfig appConfig;
  final RemoteRiftApiClient apiClient;
  final ServiceRegistry serviceRegistry;

  CancelableStream<RemoteRiftStatusResponse>? _statusStream;
  RetryScheduler? _reconnectScheduler;
  AppLifecycleListener? _lifecycleListener;

  void initialize() {
    if (state is! Initial) {
      throw StateError('Tried to initialize while not in initial state (was ${state.runtimeType})');
    }
    _initLifecycleListener();
    _connectToGameApi();
  }

  void reconnectAfterIncompatibility() {
    if (state is! ConnectedIncompatible) {
      throw StateError(
        'Tried to reconnect while not in incompatible state (was ${state.runtimeType})',
      );
    }
    _connectToGameApi();
  }

  void reconnectAfterError() {
    final connectionError = switch (state) {
      ConnectionError state => state,
      _ => throw StateError(
        'Tried to reconnect while not in error state (was ${state.runtimeType})',
      ),
    };

    final scheduler = _reconnectScheduler;
    if (scheduler == null || scheduler.status == .idle) {
      throw StateError('Reconnect scheduler was not running while in connection error state');
    }

    emit(connectionError.produce((draft) => draft.reconnectTriggered = true));
    scheduler.trigger();
  }

  void _connectToGameApi() async {
    emit(Connecting());
    if (await _resolveApiAddress()) {
      switch (await _verifyApiConnection()) {
        case .allowed:
          _initStatusListener();
        case .apiVersionToLow:
          emit(ConnectedIncompatible(cause: .apiVersionTooLow));
        case .unsuccessful:
          break;
      }
    } else {
      _initReconnectScheduler();
      emit(ConnectionError(cause: .serviceNotFound));
    }
  }

  Future<void> _reconnectToGameApi() async {
    if (await _resolveApiAddress()) {
      switch (await _verifyApiConnection()) {
        case .allowed:
          _initStatusListener();
        case .apiVersionToLow:
          emit(ConnectedIncompatible(cause: .apiVersionTooLow));
        case .unsuccessful:
          break;
      }
    } else {
      emit(ConnectionError(cause: .serviceNotFound));
    }
  }

  Future<bool> _resolveApiAddress() async {
    final apiAddress = await serviceRegistry.discover(timeLimit: Duration(seconds: 5));
    apiClient.setApiAddress(apiAddress?.toAddressString());
    return apiAddress != null;
  }

  Future<ApiConnectionVerificationResult> _verifyApiConnection() async {
    final serviceInfo = await _connectApiCatching(apiClient.getServiceInfo);
    if (serviceInfo == null) {
      return .unsuccessful;
    }
    if (_verifyApiMinVersion(serviceInfo)) {
      return .allowed;
    } else {
      return .apiVersionToLow;
    }
  }

  bool _verifyApiMinVersion(RemoteRiftApiServiceInfo info) {
    try {
      final apiVersion = Version.parse(info.version);
      final minVersion = Version.parse(appConfig.apiMinVersion);
      return apiVersion.isAtLeast(minVersion);
    } on VersionError {
      // Give the benefit of the doubt and allow connection attempt.
      return true;
    }
  }

  void _initStatusListener() {
    final stream = apiClient
        .getStatusStream(timeLimit: Duration(seconds: 10))
        .peek(onDone: _connectToGameApi)
        .cancelable();
    _statusStream?.cancel();
    _statusStream = stream;
    _listenStatus(stream);
  }

  void _listenStatus(Stream<RemoteRiftStatusResponse> statusStream) async {
    _connectApiCatching(() async {
      await for (var response in statusStream) {
        if (state is ConnectionError) {
          _reconnectScheduler?.reset();
        }

        switch (response) {
          case RemoteRiftData(value: .ready):
            emit(Connected());

          case RemoteRiftData(value: .unavailable):
            emit(Connecting());

          case RemoteRiftError error:
            emit(ConnectedWithError(cause: error));
        }
      }
    });
  }

  Future<T?> _connectApiCatching<T>(FutureOr<T> Function() callback) async {
    try {
      return await callback();
    } catch (error) {
      if (state case Connecting() || Connected() || ConnectedWithError()) {
        _initReconnectScheduler();
      }

      final ConnectionErrorCause cause = switch (error) {
        ApiConnectionTimeout() => .connectionLost,
        _ => .unknown,
      };
      emit(ConnectionError(cause: cause));
    }

    return null;
  }

  void _initLifecycleListener() {
    _lifecycleListener = AppLifecycleListener(listener: _onAppLifecycleChanged)..register();
  }

  void _onAppLifecycleChanged(AppLifecycleState from, AppLifecycleState to) {
    if (from == .paused) {
      switch (state) {
        case ConnectionError():
          _initReconnectScheduler();
        case Connecting() || Connected() || ConnectedWithError() || ConnectedIncompatible():
          _connectToGameApi();
        case Initial():
          // No need to resume the connection at this point.
          break;
      }
    } else if (to == .paused) {
      _statusStream?.cancel();
      _reconnectScheduler?.reset();
    }
  }

  void _initReconnectScheduler() {
    _reconnectScheduler = RetryScheduler(backoff: .standard, onRetry: _reconnectToGameApi)..start();
  }

  @override
  Future<void> close() {
    _statusStream?.cancel();
    _reconnectScheduler?.reset();
    _lifecycleListener?.unregister();
    return super.close();
  }
}

enum ApiConnectionVerificationResult { allowed, apiVersionToLow, unsuccessful }
