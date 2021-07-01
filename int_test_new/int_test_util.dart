import 'package:mca_driver_app/repo/auth/auth_repo.dart';
import 'package:mca_driver_app/services/endpoint_service.dart';
import 'package:mca_driver_app/util/mca_http_client.dart';
import 'test_env.dart';

class AuthClientParts {
  EndpointService endpointService;
  McaHttpClient mcaHttpClient;
}

Future<AuthClientParts> establishAuthenticatedClient(
    String user, String pass) async {
  var endpointSvc = EndpointService()..baseUrl = intTestBaseUrl;

  var api = McaHttpClient(endpointSvc);
  var ar = AuthRepo(api);

  var dto = await ar.authenticate(user, pass);
  endpointSvc.jwt = dto.authToken;

  endpointSvc.loginSession = dto.user;

  return AuthClientParts()
    ..endpointService = endpointSvc
    ..mcaHttpClient = api;
}

Future<McaHttpClient> establishAuthenticatedIntTestClient() async {
  var matter =
      await establishAuthenticatedClient(intTestDriver, intTestPassword);
  return matter.mcaHttpClient;
}
