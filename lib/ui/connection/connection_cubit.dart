import 'dart:async';
import 'dart:ui';

import 'package:cancelable_stream/cancelable_stream.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/local_storage.dart';
import '../../data/models.dart';
import '../../data/remote_rift_api.dart';
import '../../utils/retry_scheduler.dart';
import '../../utils/stream_extensions.dart';
import '../common/app_lifecycle_listener.dart';
import 'connection_state.dart';

class ConnectionCubit extends Cubit<ConnectionState> {
  ConnectionCubit({required this.remoteRiftApi, required this.localStorage}) : super(Initial());

  final RemoteRiftApi remoteRiftApi;
  final LocalStorage localStorage;

  CancelableStream<RemoteRiftStatusResponse>? _statusStream;
  RetryScheduler? _reconnectScheduler;
  AppLifecycleListener? _lifecycleListener;

  void initialize() {
    if (state is! Initial) {
      throw StateError('Tried to initialize while not in initial state (was ${state.runtimeType})');
    }
    _initLifecycleListener();
    _initConnectingToGameApi();
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
      throw StateError('Reconnect scheduler was not running while in connection erro state');
    }

    emit(connectionError.produce((draft) => draft.reconnectTriggered = true));
    scheduler.trigger();
  }

  void _initConnectingToGameApi() async {
    await for (var apiAddress in localStorage.apiAddressStream) {
      remoteRiftApi.setApiAddress(apiAddress);
      _connectToGameApiAt(apiAddress);
    }
  }

  void _connectToCurrentGameApi() async {
    final apiAddress = await localStorage.getApiAddress();
    _connectToGameApiAt(apiAddress);
  }

  void _connectToGameApiAt(String? apiAddress) {
    if (_verifyApiAddress(apiAddress) case var apiAddress?) {
      emit(Connecting());
      _resetStatusListener(apiAddress);
    }
  }

  Future<void> _reconnectToGameApi() async {
    final apiAddress = await localStorage.getApiAddress();
    if (_verifyApiAddress(apiAddress) case var apiAddress?) {
      final completer = Completer<void>();
      _resetStatusListener(apiAddress, onConnectionAttempted: completer.complete);
      await completer.future;
    }
  }

  String? _verifyApiAddress(String? apiAddress) {
    if (apiAddress case null || '') {
      _onApiAddressMissing();
      return null;
    }
    return apiAddress;
  }

  void _onApiAddressMissing() {
    emit(ConfigurationRequired());
    _statusStream?.cancel();
    _reconnectScheduler?.reset();
  }

  void _resetStatusListener(String apiAddress, {VoidCallback? onConnectionAttempted}) {
    final stream = remoteRiftApi
        .getStatusStream()
        .peek(onFirstOrError: onConnectionAttempted, onDone: _connectToCurrentGameApi)
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
          case Initial() || ConfigurationRequired():
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
      emit(ConnectionError());
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
          _connectToCurrentGameApi();
        case Initial() || ConfigurationRequired():
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
