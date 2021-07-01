import '../../stop_stage.dart';
import '../../stop_type.dart';

abstract class BaseStopDto {
  String stopId;
  String locationName;
  String locationShortAddress;
  String locationAddress;
  DateTime scheduledTime;
  bool isTimeAsap;
  StopType stopType;
  StopStage stopStatus;
  bool requireRecipient;
}
