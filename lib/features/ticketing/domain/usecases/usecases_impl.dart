import '../../data/repositories/ticket_repository.dart';
import '../models/station_model.dart';
import '../usecases/usecases.dart';
import '../../data/datasources/encryption_service.dart';

class GenerateQrUsecaseImpl implements GenerateQrUsecase {
  final TicketRepository repository;
  final EncryptionService encryptionService;

  GenerateQrUsecaseImpl({
    required this.repository,
    required this.encryptionService,
  });

  @override
  Future<String> call({
    required int ticketNumber,
    required int stationCount,
    required StationModel sourceStation,
    required StationModel destinationStation,
    required String encryptionKey,
  }) async {
    final bytes = repository.generateQrBytes(
      ticketNumber: ticketNumber,
      stationCount: stationCount,
      sourceId: sourceStation.id,
      destinationId: destinationStation.id,
    );

    return encryptionService.encryptData(bytes, encryptionKey);
  }
}

class CalculateExpDateUsecaseImpl implements CalculateExpDateUsecase {
  final TicketRepository repository;

  CalculateExpDateUsecaseImpl({required this.repository});

  @override
  String call({
    required DateTime issueDate,
    required int stationCount,
  }) {
    return repository.calculateExpDate(issueDate, stationCount);
  }
}

class GenerateTicketIdUsecaseImpl implements GenerateTicketIdUsecase {
  final TicketRepository repository;

  GenerateTicketIdUsecaseImpl({required this.repository});

  @override
  String call(DateTime dateTime) {
    return repository.generateTicketId(dateTime);
  }
}

class GetStationsUsecaseImpl implements GetStationsUsecase {
  final TicketRepository repository;

  GetStationsUsecaseImpl({required this.repository});

  @override
  List<StationModel> call() {
    return repository.getStations();
  }
}

class GetDestinationStationUsecaseImpl implements GetDestinationStationUsecase {
  final TicketRepository repository;

  GetDestinationStationUsecaseImpl({required this.repository});

  @override
  StationModel call({
    required StationModel sourceStation,
    required int count,
  }) {
    return repository.getDestinationStation(sourceStation, count);
  }
}



