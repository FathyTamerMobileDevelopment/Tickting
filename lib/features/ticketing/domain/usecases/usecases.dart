import '../models/station_model.dart';

abstract class GenerateQrUsecase {
  Future<String> call({
    required int ticketNumber,
    required int stationCount,
    required StationModel sourceStation,
    required StationModel destinationStation,
    required String encryptionKey,
  });
}

abstract class CalculateExpDateUsecase {
  String call({
    required DateTime issueDate,
    required int stationCount,
  });
}

abstract class GenerateTicketIdUsecase {
  String call(DateTime dateTime);
}

abstract class GetStationsUsecase {
  List<StationModel> call();
}

abstract class GetDestinationStationUsecase {
  StationModel call({
    required StationModel sourceStation,
    required int count,
  });
}


