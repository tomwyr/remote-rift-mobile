import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:remote_rift_core/remote_rift_core.dart';
import 'package:remote_rift_utils/remote_rift_utils.dart';
import 'package:web_socket_channel/io.dart';

class RemoteRiftApiClient {
  RemoteRiftApiClient({required HttpClient client})
    : httpClient = IOClient(client),
      webSocketClient = client;

  final Client httpClient;
  final HttpClient webSocketClient;

  String? _apiAddress;
  void setApiAddress(String? value) {
    _apiAddress = value;
  }

  Future<RemoteRiftApiServiceInfo> getServiceInfo() async {
    final url = '${await _httpBaseUrl}/service/info';
    final response = await httpClient.get(.parse(url));
    return .fromJson(jsonDecode(response.body));
  }

  Stream<RemoteRiftResponse<RemoteRiftStatus>> getStatusStream({Duration? timeLimit}) async* {
    final url = '${await _webSocketBaseUrl}/status/watch';
    final ws = IOWebSocketChannel.connect(Uri.parse(url), customClient: webSocketClient);
    final stream = _applyTimeLimit(ws.stream, timeLimit);
    await for (var message in stream) {
      yield .fromJson(jsonDecode(message), RemoteRiftStatus.fromJson);
    }
  }

  Stream<RemoteRiftSession> getCurrentSessionStream() async* {
    final url = '${await _webSocketBaseUrl}/session/watch';
    final ws = IOWebSocketChannel.connect(Uri.parse(url), customClient: webSocketClient);
    await for (var message in ws.stream) {
      yield .fromJson(jsonDecode(message));
    }
  }

  Future<void> createLobby({required int queueId}) async {
    final url = '${await _httpBaseUrl}/lobby/create?queueId=$queueId';
    await httpClient.post(.parse(url));
  }

  Future<void> leaveLobby() async {
    final url = '${await _httpBaseUrl}/lobby/leave';
    await httpClient.post(.parse(url));
  }

  Future<void> searchMatch() async {
    final url = '${await _httpBaseUrl}/queue/start';
    await httpClient.post(.parse(url));
  }

  Future<void> stopMatchSearch() async {
    final url = '${await _httpBaseUrl}/queue/stop';
    await httpClient.post(.parse(url));
  }

  Future<void> acceptMatch() async {
    final url = '${await _httpBaseUrl}/queue/accept';
    await httpClient.post(.parse(url));
  }

  Future<void> declineMatch() async {
    final url = '${await _httpBaseUrl}/queue/decline';
    await httpClient.post(.parse(url));
  }

  Future<String> get _httpBaseUrl async {
    final apiAddress = await _requireApiAddres();
    return 'http://$apiAddress';
  }

  Future<String> get _webSocketBaseUrl async {
    final apiAddress = await _requireApiAddres();
    return 'ws://$apiAddress';
  }

  Future<String> _requireApiAddres() async {
    if (_apiAddress case var value?) {
      return value;
    } else {
      throw ApiAddressNotSet();
    }
  }

  Stream<T> _applyTimeLimit<T>(Stream<T> stream, Duration? timeLimit) {
    if (timeLimit == null) return stream;

    return stream.timeout(
      timeLimit,
      onTimeout: (sink) {
        sink.addError(ApiConnectionTimeout());
        sink.close();
      },
    );
  }
}

sealed class RemoteRiftApiError implements Exception {}

class ApiAddressNotSet extends RemoteRiftApiError {}

class ApiConnectionTimeout extends RemoteRiftApiError {}
