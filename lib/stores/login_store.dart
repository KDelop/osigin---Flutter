import 'dart:async';

import '../services/logger.dart';

import '../repo/auth/auth_exception.dart';
import '../services/endpoint_service.dart';

import '../repo/auth/auth_repo.dart';
import '../services/notification/push_notification_connector.dart';
import '../services/push_notification/pushy_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

final String authTokenKey = 'auth.token';
final String authUserKey = 'auth.user';
final String authBaseUrl = 'auth.baseUrl';

class LoginStore {
  /// Does this login store polled storage/network resources to depict
  /// the current state of login?
  BehaviorSubject<bool> isInitialized;
  BehaviorSubject<bool> isAuthenticated;
  BehaviorSubject<String> authenticatedUser =
      BehaviorSubject<String>.seeded("");
  BehaviorSubject<bool> isLoading;
  BehaviorSubject<String> pushToken;
  BehaviorSubject<List<String>> errors;

  final AuthRepo _authRepo;
  final PushyService _pushSvc;
  final EndpointService _endpointSvc;
  final PushNotificationConnector _pushNotificationConnector;

  LoginStore(this._authRepo, this._pushSvc, this._endpointSvc,
      this._pushNotificationConnector) {
    isAuthenticated = BehaviorSubject<bool>.seeded(false);
    isInitialized = BehaviorSubject<bool>.seeded(false);
    isLoading = BehaviorSubject<bool>.seeded(false);
    pushToken = BehaviorSubject<String>.seeded('');
    errors = BehaviorSubject<List<String>>.seeded([]);
  }

  // The active authentication token
  String get authToken => _endpointSvc.jwt;

  /// Check prefs for credentials/tokens
  Future<void> initialize() async {
    try {
      await _getPushToken();
      await _checkForPreviousCookie();
    } finally {
      isInitialized.value = true;
    }
  }

  void _processAuthentication(String jwt, String username) {
    _endpointSvc.jwt = jwt;

    _authRepo.advertizePushToken(pushToken.value);

    authenticatedUser.value = username;

    _pushNotificationConnector.connect();

    isAuthenticated.value = true;

    errors.value = [];
  }

  void authenticate(String username, String password) async {
    var minimumCompletionTime = Future.delayed(Duration(milliseconds: 500));

    isLoading.value = true;

    try {
      var result = await _authRepo.authenticate(username, password);

      var _jwt = result.authToken;
      var prefs = await SharedPreferences.getInstance();

      // Save creds...
      prefs.setString(authTokenKey, _jwt);
      prefs.setString(authUserKey, username);
      prefs.setString(authBaseUrl, _endpointSvc.baseUrl);

      _endpointSvc.loginSession = result.user;
      _processAuthentication(result.authToken, username);
    } on AuthException catch (e) {
      errors.value = errors.value + [e.cause];
      authenticatedUser.value = '';
    } on Exception catch (e) {
      errors.value = errors.value + [e.toString()];
      authenticatedUser.value = '';
    } finally {
      await minimumCompletionTime;
      isLoading.value = false;
    }
  }

  void logOut() async {
    _pushNotificationConnector.disconnect();
    isAuthenticated.value = false;

    (await SharedPreferences.getInstance()).remove(authTokenKey);
    _endpointSvc.loginSession = null;
    _endpointSvc.jwt = null;
  }

  Future<void> _getPushToken() async {
    var value = await _pushSvc.getDeviceToken();
    pushToken.value = value;
  }

  Future<void> _checkForPreviousCookie() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(authTokenKey);
    var username = prefs.getString(authUserKey);
    var baseUrl = prefs.getString(authBaseUrl);

    if (token != null) {
      var previousJwt = token;

      try {
        var verifyResult = await _authRepo.verifyTokenIsValid(previousJwt);
        var isValid = verifyResult != null;

        if (isValid) {
          // it's good, lets set it
          _endpointSvc.jwt = previousJwt;
          _endpointSvc.loginSession = verifyResult;
          _endpointSvc.baseUrl = baseUrl;

          _processAuthentication(_endpointSvc.jwt, username);
        } else {
          _endpointSvc.jwt = null;
        }
      } on AuthException {
        // It's not good, lets clear the token.
        _endpointSvc.jwt = null;
      } on Exception catch (e) {
        logger.e(e);
        _endpointSvc.jwt = null;
      }
    }
  }
}
