import 'package:flutter_test/flutter_test.dart';
import 'package:mca_driver_app/any.dart';
import 'package:mca_driver_app/services/endpoint_service.dart';
import 'package:mca_driver_app/util/mca_http_client.dart';

const String httpBinHost = 'http://localhost:8040';

void main() {
  McaHttpClient client;
  EndpointService endpointSvc;

  setUp(() {
    endpointSvc = EndpointService()..baseUrl = httpBinHost;
    client = McaHttpClient(endpointSvc);
  });

  group('McaHttpClient', () {
    test('getJson w/o jwt', () async {
      var result = await client.getJson('/get');
      expect(result['url'], equals('$httpBinHost/get'));
    });

    test('getJson w/ jwt', () async {
      endpointSvc.jwt = guid();

      var result = await client.getJson('/get');

      expect(result['headers']['Accept'], contains('application/json'));
      expect(result['headers']['Authorization'], contains(endpointSvc.jwt));
    });

    test('postJson w/ jwt', () async {
      var testGuid = guid();

      endpointSvc.jwt = guid();

      var result = await client.postJson('/post', {"testGuid": testGuid});

      expect(result['url'], equals('$httpBinHost/post'));
      expect(result['json'], equals({"testGuid": testGuid}));
      expect(result['headers']['Authorization'], contains(endpointSvc.jwt));
    });

    test('getJson w/ data', () async {
      // This one will return html
      var result = await client.getJson('/links/2/2');

      expect(result['contentType'], contains('text/html'));
      expect(result['body'], isNotNull);
    });

    test('postJson when error code', () async {
      expect(() => client.postJson('/status/401', {}),
          throwsA(predicate((_) => _ is McaHttpClientException)));
    });

    test('getJson when error code', () async {
      expect(() => client.getJson('/status/401'),
          throwsA(predicate((_) => _ is McaHttpClientException)));
    });
  });
}
