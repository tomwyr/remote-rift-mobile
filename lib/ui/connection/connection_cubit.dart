import 'dart:async';
import 'dart:ui';

import 'package:cancelable_stream/cancelable_stream.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_connector_api/remote_rift_connector_api.dart';

import '../../data/api_client.dart';
import '../../data/models.dart';
import '../../utils/retry_scheduler.dart';
import '../../utils/stream_extensions.dart';
import '../common/app_lifecycle_listener.dart';
import 'connection_state.dart';

class ConnectionCubit extends Cubit<ConnectionState> {
  ConnectionCubit({required this.apiClient, required this.apiService}) : super(Initial());

  final RemoteRiftApiClient apiClient;
  final RemoteRiftApiService apiService;

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

  void reconnect() {
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
    if (await _resolveApiAddress()) {
      emit(Connecting());
      _resetStatusListener();
    }
  }

  Future<void> _reconnectToGameApi() async {
    if (await _resolveApiAddress()) {
      final completer = Completer<void>();
      _resetStatusListener(onConnectionAttempted: completer.complete);
      await completer.future;
    }
  }

  Future<bool> _resolveApiAddress() async {
    final apiAddress = await apiService.findAddress();
    apiClient.setApiAddress(apiAddress?.toAddressString());

    if (apiAddress == null) {
      _initReconnectScheduler();
      emit(ConnectionError(cause: .serviceNotFound));
    }

    return apiAddress != null;
  }

  void _resetStatusListener({VoidCallback? onConnectionAttempted}) {
    final stream = apiClient
        .getStatusStream()
        .peek(onFirstOrError: onConnectionAttempted, onDone: _connectToGameApi)
        .cancelable();
    _statusStream?.cancel();
    _statusStream = stream;
    _listenStatus(stream);
  }

  void _listenStatus(Stream<RemoteRiftStatusResponse> statusStream) async {
    try {
      await for (var response in statusStream) {
        if (state is ConnectionError) {
          _reconnectScheduler?.reset();
        }

        switch (state) {
          case Connecting() || ConnectedWithError() || ConnectionError() || Connected():
            // Can emit from the current state
            break;
          case Initial():
            throw StateError(
              'Tried to update connection status in an unexpected state: ${state.runtimeType}',
            );
        }

        switch (response) {
          case RemoteRiftData(value: .ready):
            if (state is! Connected) {
              emit(Connected());
            }

          case RemoteRiftData(value: .unavailable):
            emit(ConnectedWithError(cause: .unableToConnect));

          case RemoteRiftError error:
            emit(ConnectedWithError(cause: error));
        }
      }
    } catch (_) {
      if (state case Connecting() || Connected()) {
        _initReconnectScheduler();
      }
      emit(ConnectionError(cause: .unknown));
    }
  }

  void _initLifecycleListener() {
    _lifecycleListener = AppLifecycleListener(listener: _onAppLifecycleChanged)..register();
  }

  void _onAppLifecycleChanged(AppLifecycleState from, AppLifecycleState to) {
    if (from == .paused) {
      switch (state) {
        case ConnectionError():
          _initReconnectScheduler();
        case Connecting() || Connected() || ConnectedWithError():
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
