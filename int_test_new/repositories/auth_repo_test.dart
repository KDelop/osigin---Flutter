import 'package:flutter_test/flutter_test.dart';
import 'package:mca_driver_app/models/dto/mca_sails/login_dto.dart';
import 'package:mca_driver_app/repo/auth/auth_exception.dart';
import 'package:mca_driver_app/repo/auth/auth_repo.dart';
import 'package:mca_driver_app/services/endpoint_service.dart';
import 'package:mca_driver_app/util/mca_http_client.dart';

import '../test_env.dart';

void main() {
  AuthRepo authRepo;
  McaHttpClient mcaHttpClient;
  EndpointService endpointSvc;

  Future<LoginDto> doLogin() async {
    return authRepo.authenticate(intTestDriver, intTestPassword);
  }

  setUpAll(() {
    endpointSvc = EndpointService()..baseUrl = intTestBaseUrl;
    mcaHttpClient = McaHttpClient(endpointSvc);
    authRepo = AuthRepo(mcaHttpClient);
  });

  group('authenticate', () {
    test('authentication works with $intTestDriver:$intTestPassword', () async {
      var result = await authRepo.authenticate(intTestDriver, intTestPassword);

      expect(result.success, equals(true));
      expect(result.authToken, isNotNull);
      expect(result.authTokenExpiration, isNotNull);
    });

    test('AuthException is thrown with baduser/badpassword', () async {
      expect(() => authRepo.authenticate("baduser", "badpassword!"),
          throwsA(allOf((_) => _ is AuthException)));
    });
  });

  group('verifyToken', () {
    test('returns null when token is not valid', () async {
      var result = await authRepo.verifyTokenIsValid('000000');
      expect(result, equals(null));
    });

    test('returns true when token is valid', () async {
      var loginResult =
          await authRepo.authenticate(intTestDriver, intTestPassword);

      var result = await authRepo.verifyTokenIsValid(loginResult.authToken);

      expect(result, isNot(null));
    });
  });

  group('advertisePushToken', () {
    test('sends token to backend successfully', () async {
      // Make sure we're logged in
      var loginDto = await doLogin();
      endpointSvc.jwt = loginDto.authToken;

      await authRepo.advertizePushToken('token!!');
    });
  });
}
