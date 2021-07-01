import 'dart:convert';

import 'package:http/http.dart';
import '../services/endpoint_service.dart';
import '../repo/util.dart';

typedef HttpClientFactory = _AuthenticatedClient Function();

typedef BaseUrlResolver = String Function();

/// This can interact with the HTTP API, referencing a singleton for the
/// baseUrl and jwt in context.
class McaHttpClient {
  EndpointService _endpointSvc;

  McaHttpClient(this._endpointSvc);

  McaHttpClient.usingBaseUrl(String baseUrl) {
    _endpointSvc = EndpointService()..baseUrl = baseUrl;
  }

  get _baseUrl => _endpointSvc.baseUrl;
  get _jwt => _endpointSvc.jwt;

  Future<dynamic> getJson(String path, {String tempJwt}) async {
    path = _normalizePath(path);

    return withClient((client) async {
      var response = await client
          .get("$_baseUrl$path", headers: {'Accept': 'application/json'});

      _assertStatusCode(response);

      var jsonBody = _getData(response);

      return jsonBody;
    }, cf: () => _AuthenticatedClient(jwt: tempJwt ?? _jwt));
  }

  Future<Map<String, dynamic>> postJson(
      String path, Map<String, dynamic> jsonMap) async {
    path = _normalizePath(path);

    return withClient((client) async {
      var response = await client.post("$_baseUrl$path",
          body: json.encode(jsonMap),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          });

      _assertStatusCode(response);

      var jsonBody = _getData(response);

      return jsonBody;
    }, cf: () => _AuthenticatedClient(jwt: _jwt));
  }

  Future<Map<String, dynamic>> putJson(
      String path, Map<String, dynamic> jsonMap) async {
    path = _normalizePath(path);

    return withClient((client) async {
      var response = await client.put("$_baseUrl$path",
          body: json.encode(jsonMap),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          });

      _assertStatusCode(response);

      var jsonBody = _getData(response);

      return jsonBody;
    }, cf: () => _AuthenticatedClient(jwt: _jwt));
  }

  String _normalizePath(String path) {
    if (path[0] != '/') {
      return '/$path';
    }

    return path;
  }

  // Might be a map or a hashmap
  dynamic _getData(Response httpResponse) {
    var contentType = httpResponse.headers['content-type'] ?? '';

    // Shim this into a Map if we don't get json in response.
    if (!contentType.contains("application/json")) {
      return {'contentType': contentType, 'body': httpResponse.body};
    }

    return json.decode(httpResponse.body);
  }

  _assertStatusCode(Response response) {
    var statusCode = response.statusCode;

    if (statusCode > 299) {
      throw McaHttpClientException("status code $statusCode", response);
    }
  }
}

class McaHttpClientException implements Exception {
  /// 'cause' string may have something useful for the UI.
  String cause;
  Response response;

  McaHttpClientException(this.cause, this.response);

  @override
  String toString() {
    return 'McaHttpClientException: $cause on ${response.request.url}\n'
        '${response.body}';
  }
}

class _AuthenticatedClient extends BaseClient {
  final Client _inner = Client();
  final String _jwt;

  _AuthenticatedClient({String jwt}) : _jwt = jwt;

  Future<StreamedResponse> send(BaseRequest request) {
    if (_jwt != null) {
      request.headers['Authorization'] = "$_jwt";
    }

    return _inner.send(request);
  }

  void close() {
    return _inner.close();
  }
}
