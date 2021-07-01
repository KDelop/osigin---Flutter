import 'package:mca_driver_app/models/dto/mca_sails/dropoff_item_dto.dart';
import 'package:mca_driver_app/models/dto/mca_sails/pickup_item_dto.dart';
import 'package:mca_driver_app/models/dto/mca_sails/stop_detail_dto.dart';
import 'package:mca_driver_app/models/dto/mca_sails/stop_list_item_dto.dart';
import 'package:mca_driver_app/models/recipient_model.dart';
import 'package:mca_driver_app/repo/util.dart';
import 'package:mca_driver_app/services/logger.dart';

import '../models/dto/mca_sails/item_dto.dart';
import '../util/mca_http_client.dart';

class StopRepository {
  final McaHttpClient _mcaHttpClient;

  StopRepository(this._mcaHttpClient);

  Future<List<StopListItemDto>> listMyStops() async {
    var range = getRangeForDay(DateTime.now());

    List<dynamic> json = await _mcaHttpClient.getJson('/mobile/stops'
        '?startDate=${range.start}'
        '&endDate=${range.end}');

    var stopDetailDtos = json
        .map((stopDetailJson) => StopListItemDto.fromJson(stopDetailJson))
        .toList();

    return stopDetailDtos;
  }

  Future<StopDetailDto> getById(String id) async {
    dynamic json = await _mcaHttpClient.getJson('/mobile/stops/$id');
    // logger.i(json);

    return StopDetailDto.fromJson(json);
  }

  Future<void> completePickup(
    String id, {
    List<ItemDto> items = const [],
    List<Map> photos = const [],
    RecipientModel recipient,
    String driverNotes = '',
  }) async {
    var res = await _mcaHttpClient.putJson(
      '/mobile/stops/$id/completion',
      {
        'items': items.map((i) => i.toJson()).toList(),
        'photos': photos,
        'recipient': recipient?.toJson(),
        'driverNotes': driverNotes,
      },
    );
    // logger.i('photos ===>>> ${res['stop']['photos']}');
    // logger.i('recipient ===>>> ${res['stop']['recipient']}');
    // logger.i('driverNotes ===>>> ${res['stop']['driverNotes']}');
  }

  Future<void> savePickupItems(
    String orderId,
    String stopId, {
    List<PickupItemDto> items = const [],
  }) async {
    var res = await _mcaHttpClient.putJson(
      'mobile/stops/pickedup',
      {
        'orderId': orderId,
        'stopId': stopId,
        'stopItems': items.map((i) => i.toJson()).toList(),
      },
    );
    // logger.i('picked up items =>>> ${res['stopItems']}');
  }

  Future<void> completeDropoff(
    String id, {
    List<ItemDto> items,
    List<Map> photos = const [],
    RecipientModel recipient,
    String driverNotes = '',
  }) async {
    var res = await _mcaHttpClient.putJson('/mobile/stops/$id/completion', {
      'items': items.map((i) => i.toJson()).toList(),
      'photos': photos,
      'recipient': recipient?.toJson(),
      'driverNotes': driverNotes,
    });
    // logger.i('photos ===>>> ${res['stop']['photos']}');
    // logger.i('recipient ===>>> ${res['stop']['recipient']}');
    // logger.i('driverNotes ===>>> ${res['stop']['driverNotes']}');
  }

  Future<void> saveDropoffItems(
    String orderId,
    String stopId, {
    List<DropoffItemDto> items = const [],
  }) async {
    var res = await _mcaHttpClient.putJson(
      'mobile/stops/dropoff',
      {
        'orderId': orderId,
        'stopId': stopId,
        'stopItems': items.map((i) => i.toJson()).toList(),
      },
    );
    // logger.i('drop off: stopItems =>>> ${res['stopItems']}');
    // logger.i('drop off: pickedupStopItems =>>> ${res['pickedupStopItems']}');
  }
}
