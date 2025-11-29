import 'dart:async';

import 'package:cancelable_stream/cancelable_stream.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/local_storage.dart';
import '../../data/models.dart';
import '../../data/remote_rift_api.dart';
import '../../utils/retry_scheduler.dart';
import '../../utils/stream_extensions.dart';
import 'connection_state.dart';

class ConnectionCubit extends Cubit<ConnectionState> {
  ConnectionCubit({required this.remoteRiftApi, required this.localStorage}) : super(Initial());

  final RemoteRiftApi remoteRiftApi;
  final LocalStorage localStorage;

  CancelableStream<RemoteRiftStatusResponse>? _statusStream;
  RetryScheduler? _reconnectScheduler;

  void initialize() {
    if (state is! Initial) {
      throw StateError('Tried to initialize while not in initial state (was ${state.runtimeType})');
    }
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
          default:
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
        _reconnectScheduler = _createReconnectScheduler()..start();
      }
      emit(ConnectionError());
    }
  }

  RetryScheduler _createReconnectScheduler() {
    return RetryScheduler(backoff: .standard, onRetry: _reconnectToGameApi);
  }
}
