import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mca_driver_app/any.dart';
import 'package:mca_driver_app/models/dto/mca_sails/login_dto.dart';
import 'package:mca_driver_app/repo/auth/auth_exception.dart';
import 'package:mca_driver_app/repo/auth/auth_repo.dart';
import 'package:mca_driver_app/services/endpoint_service.dart';
import 'package:mca_driver_app/services/notification/push_notification_connector.dart';
import 'package:mca_driver_app/services/push_notification/pushy_service.dart';
import 'package:mca_driver_app/stores/login_store.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

class MockPushNotificationConnector extends Mock
    implements PushNotificationConnector {}

class MockPushyService extends Mock implements PushyService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  AuthRepo authRepo;
  PushNotificationConnector pushNotifConnector;
  MockPushyService mockPushyService;
  EndpointService endpointService;

  LoginDto testLoginDto;

  final savedAuthToken = 'jwt::good!saved!token';
  final savedBaseUrl = 'http://example.com/foo';

  LoginStore buildLoginStore(
      {bool shouldFailAuth = false,
      bool existsSavedAuth = false,
      bool savedAuthValid = false,
      bool hasGeneralError = false}) {
    testLoginDto = Any.loginDto();
    authRepo = MockAuthRepo();
    pushNotifConnector = MockPushNotificationConnector();
    mockPushyService = MockPushyService();
    endpointService = EndpointService();

    endpointService.baseUrl = 'http://default.example.com';

    when(mockPushyService.getDeviceToken())
        .thenAnswer((_) async => "pushtoken!!");

    when(authRepo.authenticate(any, any)).thenAnswer((_) async {
      if (hasGeneralError) {
        throw Exception("other error");
      }

      if (shouldFailAuth) {
        throw AuthException(AuthExceptionCode.generalError, "General Error");
      }

      return testLoginDto;
    });

    when(authRepo.verifyTokenIsValid(any)).thenAnswer((_) {
      if (hasGeneralError) {
        throw Exception("some other error, probably network");
      }

      if (!savedAuthValid) {
        return Future.value(null);
      }

      return Future.value(testLoginDto.user);
    });

    if (existsSavedAuth) {
      SharedPreferences.setMockInitialValues({
        'auth.token': savedAuthToken,
        'auth.user': 'test-user!!',
        authBaseUrl: savedBaseUrl
      });
    } else {
      SharedPreferences.setMockInitialValues({});
    }

    var loginStore = LoginStore(
        authRepo, mockPushyService, endpointService, pushNotifConnector);

    return loginStore;
  }

  test('login store still initializes if an error is thrown', () async {
    // prevents the progress spinner if something went terribly wrong.

    var loginStore =
        buildLoginStore(shouldFailAuth: false, existsSavedAuth: true);

    when(authRepo.verifyTokenIsValid(any)).thenThrow(Error);

    await expectLater(loginStore.initialize, throwsA(Error));

    expect(loginStore.authToken, equals(null));
    expect(loginStore.isLoading.value, false);
    expect(loginStore.isInitialized.value, true);
  });

  test('login store grabs previous setting', () async {
    var loginStore =
        buildLoginStore(shouldFailAuth: false, existsSavedAuth: true);

    expect(endpointService.baseUrl, equals('http://default.example.com'),
        reason: "starting test with the default");

    await loginStore.initialize();

    expect(endpointService.baseUrl, equals('http://default.example.com'),
        reason: "it should set the saved url from prior auth");

    expect(loginStore.authToken, equals(null));
    expect(loginStore.isLoading.value, false);
    expect(loginStore.isInitialized.value, true);
  });

  group('Login store, initializing with previous credentials', () {
    test('when previous credentials do not exist', () async {
      var loginStore =
          buildLoginStore(shouldFailAuth: false, existsSavedAuth: false);

      await loginStore.initialize();

      verifyNever(authRepo.verifyTokenIsValid(captureAny));

      expect(loginStore.authToken, equals(null));
      expect(loginStore.isLoading.value, false);
      expect(loginStore.isAuthenticated.value, false);
      expect(loginStore.authenticatedUser.value, equals(''));

      expect(endpointService.jwt, equals(null));
      expect(endpointService.loginSession, null);
      expect(endpointService.baseUrl, equals('http://default.example.com'),
          reason: "it should not change the baseUrl");
    });

    expectVerifyCalledWithStoredCookie(LoginStore loginStore) {
      var call = verify(authRepo.verifyTokenIsValid(captureAny)).captured[0];

      expect(call, equals(savedAuthToken));

      expect(loginStore.isLoading.value, false);
    }

    test('when previous credentials exist and are valid', () async {
      var loginStore = buildLoginStore(
          shouldFailAuth: false, existsSavedAuth: true, savedAuthValid: true);
      await loginStore.initialize();

      expectVerifyCalledWithStoredCookie(loginStore);

      // it should be logged in.
      expect(loginStore.authToken, isNot(null));
      expect(loginStore.authToken, equals(savedAuthToken));
      expect(loginStore.isAuthenticated.value, true,
          reason: "not authenticated");
      expect(loginStore.authenticatedUser.value, equals('test-user!!'));

      expect(endpointService.jwt, equals(savedAuthToken));
      expect(endpointService.baseUrl, equals(savedBaseUrl),
          reason: "It should set the saved base url from prior auth");

      expect(endpointService.loginSession, equals(testLoginDto.user),
          reason: "Should save the user info from the server");

      verify(pushNotifConnector.connect());
    });

    test('when previous credentials exist and are not valid', () async {
      var loginStore = buildLoginStore(
          shouldFailAuth: false, existsSavedAuth: true, savedAuthValid: false);

      await loginStore.initialize();

      expectVerifyCalledWithStoredCookie(loginStore);

      expect(loginStore.authToken, equals(null));
      expect(loginStore.isAuthenticated.value, false,
          reason: "not authenticated");
      expect(loginStore.authenticatedUser.value, equals(''));

      expect(endpointService.jwt, equals(null));
      expect(endpointService.loginSession, equals(null),
          reason: "Should save the user info from the server");

      verifyNever(pushNotifConnector.connect());
    });
  });

  group('Login Store authentication', () {
    String testUser, testPass;

    setUp(() {
      testUser = Faker().internet.userName();
      testPass = Faker().internet.password();
    });

    void commonAssertions(LoginStore loginStore) {
      expect(verify(authRepo.authenticate(captureAny, captureAny)).captured,
          [testUser, testPass],
          reason: "did not authenticate with given username/password");

      expect(loginStore.isLoading.value, false, reason: "still loading");
    }

    test('when authentication is successful', () async {
      var loginStore = buildLoginStore();
      await loginStore.initialize();

      endpointService.baseUrl = 'https://changed.example.com';

      await loginStore.authenticate(testUser, testPass);

      var prefs = await SharedPreferences.getInstance();

      expect(
          prefs.getString(authBaseUrl), equals('https://changed.example.com'),
          reason: "it should save the base url we authenticated with");

      commonAssertions(loginStore);

      expect(loginStore.isAuthenticated.value, true);
      expect(loginStore.authToken, equals(testLoginDto.authToken));
      expect(endpointService.jwt, equals(testLoginDto.authToken));

      expect(loginStore.authenticatedUser.value, equals(testUser));

      verify(authRepo.advertizePushToken("pushtoken!!"));

      verify(pushNotifConnector.connect());

      expect(endpointService.loginSession, testLoginDto.user);
    });

    test('when authentication is not successful', () async {
      var loginStore = buildLoginStore(shouldFailAuth: true);
      await loginStore.initialize();

      await loginStore.authenticate(testUser, testPass);

      commonAssertions(loginStore);

      expect(loginStore.isAuthenticated.value, false);
      expect(loginStore.authToken, equals(null));
      expect(loginStore.authenticatedUser.value, equals(''));

      expect(endpointService.loginSession, equals(null));

      verifyNever(authRepo.advertizePushToken(any));

      verifyNever(pushNotifConnector.connect());
    });
  });
}
