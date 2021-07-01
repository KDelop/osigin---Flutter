import '../models/dto/mca_sails/app_user_dto.dart';

/// Manages some state related to making API requests.
/// baseUrl, jwt
class EndpointService {
  String baseUrl = "https://example.com";
  String jwt;

  AppUserDto loginSession;
}
