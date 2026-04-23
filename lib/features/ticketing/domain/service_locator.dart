import 'package:lrt_ticketing/features/ticketing/domain/usecases/usecases.dart';
import 'package:lrt_ticketing/features/ticketing/domain/usecases/usecases_impl.dart';
import '../data/datasources/encryption_service.dart';
import '../data/repositories/ticket_repository.dart';
import '../presentation/cubits/ticket_cubit.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();

  factory ServiceLocator() {
    return _instance;
  }

  ServiceLocator._internal();

  late final TicketRepository _ticketRepository;
  late final EncryptionService _encryptionService;
  late final GenerateTicketIdUsecase _generateTicketIdUsecase;
  late final GetStationsUsecase _getStationsUsecase;
  late final GetDestinationStationUsecase _getDestinationStationUsecase;
  late final CalculateExpDateUsecase _calculateExpDateUsecase;
  late final GenerateQrUsecase _generateQrUsecase;
  late final TicketCubit _ticketCubit;

  void setup() {
    _ticketRepository = TicketRepositoryImpl();
    _encryptionService = EncryptionServiceImpl();

    _generateTicketIdUsecase = GenerateTicketIdUsecaseImpl(
      repository: _ticketRepository,
    );

    _getStationsUsecase = GetStationsUsecaseImpl(
      repository: _ticketRepository,
    );

    _getDestinationStationUsecase = GetDestinationStationUsecaseImpl(
      repository: _ticketRepository,
    );

    _calculateExpDateUsecase = CalculateExpDateUsecaseImpl(
      repository: _ticketRepository,
    );

    _generateQrUsecase = GenerateQrUsecaseImpl(
      repository: _ticketRepository,
      encryptionService: _encryptionService,
    );

    _ticketCubit = TicketCubit(
      generateTicketIdUsecase: _generateTicketIdUsecase,
      getStationsUsecase: _getStationsUsecase,
      getDestinationStationUsecase: _getDestinationStationUsecase,
      calculateExpDateUsecase: _calculateExpDateUsecase,
      generateQrUsecase: _generateQrUsecase,
    );
  }

  TicketCubit get ticketCubit => _ticketCubit;
  TicketRepository get ticketRepository => _ticketRepository;
  EncryptionService get encryptionService => _encryptionService;
}


