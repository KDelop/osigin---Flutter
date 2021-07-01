import 'package:ws_action/connection_service.dart';

class LocationRepository {

  final WsConnectionService _wsConnSvc;
  LocationRepository(this._wsConnSvc);

  void sendLocation(double latitude, double longitude) async {

    await _wsConnSvc.actionFut('RecordCoordinates', {
      'latitude': latitude,
      'longitude': longitude
    });

  }

}