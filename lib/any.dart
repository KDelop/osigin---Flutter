// TODO: make any a static class.. or figure out how to namespace so that
// calling code must call with prefixed Any.object()
import 'dart:math';

import 'package:faker/faker.dart';
import 'package:mca_driver_app/models/dto/mca_sails/base_stop_dto.dart';
import 'package:mca_driver_app/models/dto/mca_sails/stop_detail_dto.dart';
import 'package:mca_driver_app/services/stop_mapper.dart';
import 'models/dto/mca_sails/app_user_dto.dart';
import 'models/stop_stage.dart';
import 'models/dto/mca_sails/delivery_location_point_dto.dart';
import 'models/dto/mca_sails/login_dto.dart';
import 'models/dto/stops/delivery_item_dto.dart';

import 'models/stop_detail_vm.dart';
import 'models/notification.dart';
import 'models/delivery_item_vm.dart';
import 'models/dto/client_dto.dart';
import 'models/stop_type.dart';

final _faker = Faker();
final _random = Random();

String guid() {
  return _faker.guid.guid();
}

T pickOne<T>(List<T> list) {
  return list[_random.nextInt(list.length)];
}

List<T> pickSome<T>(List<T> list, int qty) {
  if (qty > list.length) {
    throw 'Not enough data for this list!';
  }

  var finalList = <T>[];

  var pool = List.from(list);

  for (var i = 0; i < qty; i++) {
    var nextIdx = _random.nextInt(pool.length);
    var nextItem = pool.removeAt(nextIdx);
    finalList.add(nextItem);
  }

  return finalList;
}

String phoneNumber() {
  var pfx1 = _faker.randomGenerator.integer(800, min: 100).toString();
  var pfx2 = _faker.randomGenerator.integer(8000, min: 1000).toString();

  return "402$pfx1$pfx2";
}

String url() {
  return _faker.internet.httpsUrl();
}

String locationType() {
  return pickOne(['Individual', 'Business']);
}

var _deliveryItemDesc = [
  'Pumps',
  'Lispro',
  'Amoxicillin',
  'Glumetza',
  'Atridox',
  'GE Ventillator',
];

List<DeliveryItemVm> deliveryItemVmList(int qty) {
  return _deliveryItemDesc.map((desc) {
    return DeliveryItemVm()
      ..description = desc
      ..qty = 5
      ..originalQty = 5;
  }).toList();
}

// TODO: clientNames could be a generic class that generates over a list.

var _clientNames = [
  'Walgreens',
  'CVS',
  'Bryan Hospital',
  'Bryan Family Medicine',
  'Russ\'s',
  'Neighborhood LTC Pharmacy',
  'Lincoln Pharmacy',
  'Cardinal Health',
  'Stockwell Pharmacy',
  'Genoa Pharmacy',
  'Kohll\'s Rx',
  'Target',
  'Labcorp',
  'Lincoln Urology PC',
  'CHI Health',
];

Iterable<String> _makeClientNameIterable() sync* {
  _clientNames.shuffle();
  while (true) {
    for (var line in _clientNames) {
      yield line;
    }
  }
}

Iterator<String> companyIterator = _makeClientNameIterable().iterator;

String clientName() {
  companyIterator.moveNext();
  return companyIterator.current;
}

ClientDto clientDto() {
  return ClientDto()
    ..id = _faker.guid.guid()
    ..phone = phoneNumber()
    ..contactName = _faker.person.name()
    ..specialInstructions = _faker.lorem.sentence()
    ..state = _faker.address.countryCode()
    ..updatedOn = _faker.date.dateTime().toIso8601String()
    ..zip = _faker.address.zipCode()
    ..address1 = _faker.address.streetAddress()
    ..address2 = _faker.address.buildingNumber()
    ..businessName = clientName()
    ..city = _faker.address.city()
    ..createdOn = _faker.date.dateTime().toIso8601String()
    ..email = _faker.internet.email();
}

List<String> deliveryCertifications() {
  var count = _random.nextInt(2);
  return List<String>.generate(count, (_) => certification());
}

List<String> deliveryEquipmentRequirements() {
  var count = _random.nextInt(2);
  return List<String>.generate(count, (_) => equipmentRequirement());
}

String certification() {
  return pickOne(['HazMat', 'Infectious', 'CatA']);
}

String equipmentRequirement() {
  return pickOne(['TempControl', 'HeavyLoad']);
}

DeliveryLocationPointDto sailsPickupPoints() {
  return DeliveryLocationPointDto()
    ..id = _faker.guid.guid()
    ..description = _faker.lorem.sentence()
    ..locationId = _faker.guid.guid()
    ..name = _faker.sport.name();
}

DeliveryItemVm deliveryItemVm() {
  return DeliveryItemVm()
    ..id = _faker.guid.guid()
    ..description = _faker.lorem.sentence()
    ..isAddedDuringLoadXfer = false
    ..isConfirmed = false
    ..qty = 0
    ..originalQty = 0;
}

AppNotification appNotification() {
  return AppNotification()..id = _faker.guid.guid();
}

BaseStopDto baseStopDto() {
  return StopDetailDto()
    ..stopId = guid()
    ..locationName = _faker.company.name()
    ..locationAddress = _faker.address.streetAddress()
    ..scheduledTime = _faker.date.dateTime()
    ..isTimeAsap = _faker.randomGenerator.boolean()
    ..stopType = _faker.randomGenerator.element(StopType.values)
    ..stopStatus = _faker.randomGenerator.element(StopStage.values)
    ..orderId = guid()
    ..orderName = _faker.lorem.word()
    ..requiredCerts = [certification()]
    ..requiredEquipment = [equipmentRequirement()]
    ..locationContactName = _faker.person.firstName()
    ..locationContactPhone = phoneNumber()
    ..isPartOfRoute = _faker.randomGenerator.boolean()
    ..locationInstructions = _faker.lorem.sentence()
    ..clientInstructions = _faker.lorem.sentence()
    ..stopInstructions = _faker.lorem.sentence()
    ..orderInstructions = _faker.lorem.sentence()
    ..items = []
    ..pickupPoints = ['some point'];
}

StopDetailDto stopDetailDto() {
  return StopDetailDto()
    ..stopId = guid()
    ..locationName = _faker.company.name()
    ..locationAddress = _faker.address.streetAddress()
    ..scheduledTime = _faker.date.dateTime()
    ..isTimeAsap = _faker.randomGenerator.boolean()
    ..stopType = _faker.randomGenerator.element(StopType.values)
    ..stopStatus = _faker.randomGenerator.element(StopStage.values)
    ..orderId = guid()
    ..orderName = _faker.lorem.word()
    ..requiredCerts = [certification()]
    ..requiredEquipment = [equipmentRequirement()]
    ..locationContactName = _faker.person.firstName()
    ..locationContactPhone = phoneNumber()
    ..isPartOfRoute = _faker.randomGenerator.boolean()
    ..locationInstructions = _faker.lorem.sentence()
    ..clientInstructions = _faker.lorem.sentence()
    ..stopInstructions = _faker.lorem.sentence()
    ..orderInstructions = _faker.lorem.sentence()
    ..items = []
    ..pickupPoints = ['some point'];
}

StopDetailVm stopDetailVm({List<String> pickupPoints}) {
  var dto = stopDetailDto();

  if (pickupPoints != null) {
    dto.pickupPoints = pickupPoints;
  }

  return StopMapper().mapStopDetailDtoToStopDetailVm(dto);
}

class Any {
  static DeliveryItemDto deliveryItemDto() {
    return DeliveryItemDto()
      ..deliveryId = guid()
      ..id = guid()
      ..isPrespecified = true
      ..name = _faker.food.dish()
      ..qty = _faker.randomGenerator.integer(10, min: 1);
  }

  static LoginDto loginDto() {
    return LoginDto()
      ..success = true
      ..authToken = "jwt${_faker.randomGenerator.integer(100)}"
      ..user = appUserDto();
  }
}

AppUserDto appUserDto() {
  return AppUserDto()
    ..id = guid()
    ..username = _faker.internet.userName()
    ..firstName = _faker.person.firstName()
    ..lastName = _faker.person.lastName()
    ..phone = phoneNumber()
    ..email = _faker.internet.email();
}

int orderNumber() {
  return _faker.randomGenerator.integer(10000);
}

DeliveryLocationPointDto deliveryLocationPointDto() {
  return DeliveryLocationPointDto()
    ..id = guid()
    ..name = _faker.sport.name()
    ..description = _faker.lorem.sentence();
}
