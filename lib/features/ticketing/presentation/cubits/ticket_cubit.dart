import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/models/station_model.dart';
import '../../domain/usecases/usecases.dart';

part 'ticket_event.dart';
part 'ticket_state.dart';

class TicketCubit extends Cubit<TicketState> {
  final GenerateTicketIdUsecase generateTicketIdUsecase;
  final GetStationsUsecase getStationsUsecase;
  final GetDestinationStationUsecase getDestinationStationUsecase;
  final CalculateExpDateUsecase calculateExpDateUsecase;
  final GenerateQrUsecase generateQrUsecase;

  TicketCubit({
    required this.generateTicketIdUsecase,
    required this.getStationsUsecase,
    required this.getDestinationStationUsecase,
    required this.calculateExpDateUsecase,
    required this.generateQrUsecase,
  }) : super(const TicketState());

  void initializeTicket() {
    final now = DateTime.now();
    final ticketId = generateTicketIdUsecase(now);
    final issueDate = DateFormat('dd/MM/yyyy HH:mm').format(now);
    final stations = getStationsUsecase();

    emit(state.copyWith(
      ticketId: ticketId,
      issueDate: issueDate,
      stations: stations,
    ));
  }

  void updateTicketId(String id) {
    emit(state.copyWith(ticketId: id));
  }

  void updateStationCount(String count) {
    emit(state.copyWith(stationCount: count));
  }

  void updateEncryptionKey(String key) {
    emit(state.copyWith(encryptionKey: key));
  }

  void selectStation(StationModel station) {
    emit(state.copyWith(selectedStation: station));
  }

  void updateIssueDate(String date) {
    emit(state.copyWith(issueDate: date));
    final dateTime = DateFormat('dd/MM/yyyy HH:mm').parse(date);
    final newTicketId = generateTicketIdUsecase(dateTime);
    emit(state.copyWith(ticketId: newTicketId));
  }

  Future<void> generateQR() async {
    if (state.selectedStation == null) {
      emit(state.copyWith(error: "اختار محطة الأول"));
      return;
    }

    if (state.ticketId.isEmpty ||
        state.stationCount.isEmpty ||
        state.encryptionKey.isEmpty ||
        state.issueDate.isEmpty) {
      emit(state.copyWith(error: "من فضلك املأ كل الحقول"));
      return;
    }

    final count = int.tryParse(state.stationCount);
    if (count == null) {
      emit(state.copyWith(error: "عدد المحطات غير صالح"));
      return;
    }

    try {
      emit(state.copyWith(isLoading: true, error: null));

      final issueDateTime =
          DateFormat('dd/MM/yyyy HH:mm').parse(state.issueDate);
      final expDate = calculateExpDateUsecase(
        issueDate: issueDateTime,
        stationCount: count,
      );

      final ticketNumber = int.parse(state.ticketId);
      final destination = getDestinationStationUsecase(
        sourceStation: state.selectedStation!,
        count: count,
      );

      final qrData = await generateQrUsecase(
        ticketNumber: ticketNumber,
        stationCount: count,
        sourceStation: state.selectedStation!,
        destinationStation: destination,
        encryptionKey: state.encryptionKey,
      );

      emit(state.copyWith(
        qrData: qrData,
        expDate: expDate,
        destinationStation: destination,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(error: "خطأ في توليد QR: $e", isLoading: false));
    }
  }
}

