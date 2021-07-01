import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mca_driver_app/any.dart';
import 'package:mca_driver_app/repo/auth/auth_exception.dart';
import 'package:mca_driver_app/repo/auth/auth_repo.dart';
import 'package:mca_driver_app/services/endpoint_service.dart';
import 'package:mca_driver_app/services/notification/push_notification_connector.dart';
import 'package:mca_driver_app/stores/login_store.dart';
import 'package:mca_driver_app/views/login/login_view.dart';
import 'package:mca_driver_app/services/service_locator.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../mocks.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

class MockPushNotificationConnector extends Mock
    implements PushNotificationConnector {}

void main() {
  testWidgets('LoginView authentication flow', (tester) async {
    SharedPreferences.setMockInitialValues({});

    var authRepo = MockAuthRepo();

    when(authRepo.authenticate(any, any)).thenAnswer((_) async {
      var username = _.positionalArguments[0];
      var password = _.positionalArguments[1];

      if (username == "promed@example.com" && password == "parse") {
        return Any.loginDto();
      } else {
        throw AuthException(
            AuthExceptionCode.invalidCredentials, "Invalid Credentials");
      }
    });

    // Arrange
    var loginStore = LoginStore(authRepo, MockPushyService(), EndpointService(),
        MockPushNotificationConnector());

    loginStore.isInitialized.value = true;
    loginStore.isLoading.value = false;

    sl.registerSingleton<LoginStore>(loginStore);

    await tester.pumpWidget(MaterialApp(home: LoginView()));
    await tester.pump();

    expect(find.byType(TextFormField).at(0), findsOneWidget,
        reason: "did not find email field");

    // Act
    await tester.enterText(
        find.byType(TextFormField).at(0), 'promed@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'badpass');

    await tester.tap(find.byType(RaisedButton));

    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Invalid Credentials'), findsOneWidget,
        reason: "Should show invalid credentials error");

    // Act
    await tester.enterText(
        find.byType(TextFormField).at(0), 'promed@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'parse');

    await tester.tap(find.byType(RaisedButton));

    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Invalid Credentials'), findsNothing,
        reason: "Should not show invalid credentials text");
  });
}
