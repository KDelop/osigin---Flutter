import '../models/data_status.dart';

class DataRetrievalException implements Exception {
  DataStatus dataStatus;
  String cause;

  DataRetrievalException(this.dataStatus, this.cause);
}
