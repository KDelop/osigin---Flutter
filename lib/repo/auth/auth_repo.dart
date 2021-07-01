import '../../models/dto/mca_sails/app_user_dto.dart';

import 'auth_exception.dart';
import '../../services/logger.dart';
import '../../util/mca_http_client.dart';

import '../../models/dto/mca_sails/login_dto.dart';

class AuthRepo {
  final McaHttpClient _client;

  AuthRepo(this._client);

  Future<LoginDto> authenticate(String username, String password) async {
    var result = await _client
        .postJson('/auth/login', {"username": username, "password": password});

    if (!result['success']) {
      throw AuthException(AuthExceptionCode.generalError,
          "Server indicated failure '${result['success']}'");
    }

    return LoginDto.fromJson(result);
  }

  Future<AppUserDto> verifyTokenIsValid(String jwt) async {
    try {
      var json = await _client.getJson('/testAuth/test', tempJwt: jwt);
      var success = json['success'] ?? false;
      if (success) {
        return AppUserDto.fromJson(json['user']);
      } else {
        return null;
      }
    } on Exception catch (e) {
      logger.e(e);
      return null;
    }
  }

  Future<void> advertizePushToken(String pushToken) async {
    await _client.postJson('/auth/setPushToken', {"pushToken": pushToken});
  }
}
