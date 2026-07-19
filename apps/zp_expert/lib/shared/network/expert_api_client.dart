import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class ExpertApiException implements Exception {
  const ExpertApiException({
    required this.statusCode,
    required this.code,
    required this.message,
    this.requestId,
  });

  final int statusCode;
  final String code;
  final String message;
  final String? requestId;

  @override
  String toString() => 'ExpertApiException($statusCode, $code): $message';
}

class ExpertSseEvent {
  const ExpertSseEvent({required this.name, required this.data});

  final String name;
  final Map<String, dynamic> data;
}

class ExpertApiClient {
  ExpertApiClient({required String baseUrl, required http.Client client})
      : _baseUrl = baseUrl.replaceFirst(RegExp(r'/$'), ''),
        _client = client;

  final String _baseUrl;
  final http.Client _client;

  Future<dynamic> get(String path, {String? accessToken}) => _request(
        'GET',
        path,
        accessToken: accessToken,
      );

  Future<dynamic> post(
    String path, {
    String? accessToken,
    Map<String, dynamic>? body,
  }) =>
      _request('POST', path, accessToken: accessToken, body: body);

  Future<dynamic> patch(
    String path, {
    String? accessToken,
    Map<String, dynamic>? body,
  }) =>
      _request('PATCH', path, accessToken: accessToken, body: body);

  Stream<ExpertSseEvent> events({required String accessToken}) async* {
    final http.Request request = http.Request(
      'GET',
      _uri('/api/v1/events/stream'),
    )..headers.addAll(<String, String>{
        'Accept': 'text/event-stream',
        'Authorization': 'Bearer $accessToken',
        'Cache-Control': 'no-cache',
      });
    final http.StreamedResponse response = await _client.send(request);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final String body = await response.stream.bytesToString();
      throw _error(response.statusCode, body);
    }

    String eventName = 'message';
    final List<String> dataLines = <String>[];
    await for (final String line in response.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter())) {
      if (line.isEmpty) {
        if (dataLines.isNotEmpty) {
          final dynamic decoded = jsonDecode(dataLines.join('\n'));
          if (decoded is Map<String, dynamic>) {
            yield ExpertSseEvent(name: eventName, data: decoded);
          } else if (decoded is Map) {
            yield ExpertSseEvent(
              name: eventName,
              data: Map<String, dynamic>.from(decoded),
            );
          }
        }
        eventName = 'message';
        dataLines.clear();
        continue;
      }
      if (line.startsWith(':')) continue;
      if (line.startsWith('event:')) {
        eventName = line.substring(6).trim();
      } else if (line.startsWith('data:')) {
        dataLines.add(line.substring(5).trimLeft());
      }
    }
  }

  Future<dynamic> _request(
    String method,
    String path, {
    String? accessToken,
    Map<String, dynamic>? body,
  }) async {
    final Map<String, String> headers = <String, String>{
      'Accept': 'application/json',
      if (body != null) 'Content-Type': 'application/json',
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
    };
    final http.Response response = await _client
        .send(http.Request(method, _uri(path))
          ..headers.addAll(headers)
          ..body = body == null ? '' : jsonEncode(body))
        .then(http.Response.fromStream)
        .timeout(const Duration(seconds: 60));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw _error(response.statusCode, response.body);
    }
    if (response.body.isEmpty) return null;
    final dynamic decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic> && decoded['success'] == true) {
      return decoded['data'];
    }
    return decoded;
  }

  Uri _uri(String path) => Uri.parse('$_baseUrl$path');

  ExpertApiException _error(int statusCode, String responseBody) {
    try {
      final dynamic decoded = jsonDecode(responseBody);
      if (decoded is Map) {
        final Map<dynamic, dynamic> error =
            decoded['error'] is Map ? decoded['error'] as Map : decoded;
        return ExpertApiException(
          statusCode: statusCode,
          code: error['code']?.toString() ?? 'http_$statusCode',
          message: error['message']?.toString() ?? 'Request failed.',
          requestId: decoded['requestId']?.toString(),
        );
      }
    } catch (_) {}
    return ExpertApiException(
      statusCode: statusCode,
      code: 'http_$statusCode',
      message: responseBody.isEmpty ? 'Request failed.' : responseBody,
    );
  }
}

const String _configuredBaseUrl = String.fromEnvironment(
  'ZP_API_BASE_URL',
  defaultValue: 'https://zp-backend-3fxe.onrender.com',
);

final Provider<http.Client> httpClientProvider =
    Provider<http.Client>((Ref ref) {
  final http.Client client = http.Client();
  ref.onDispose(client.close);
  return client;
});

final Provider<ExpertApiClient> expertApiClientProvider =
    Provider<ExpertApiClient>((Ref ref) {
  return ExpertApiClient(
    baseUrl: _configuredBaseUrl,
    client: ref.watch(httpClientProvider),
  );
});
