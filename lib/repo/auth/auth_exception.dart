class AuthException implements Exception {

  AuthExceptionCode code;
  /// 'cause' string may have something useful for the UI.
  String cause;

  AuthException(this.code, this.cause);

  @override
  String toString() {
    return 'AuthException: $code $cause';
  }
}

enum AuthExceptionCode {
  invalidCredentials,
  generalError
}