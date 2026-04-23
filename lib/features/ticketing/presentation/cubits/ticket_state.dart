part of 'ticket_cubit.dart';

class TicketState {
  final String ticketId;
  final String stationCount;
  final String encryptionKey;
  final String issueDate;
  final String expDate;
  final String qrData;
  final bool isLoading;
  final String? error;
  final List<StationModel> stations;
  final StationModel? selectedStation;
  final StationModel? destinationStation;

  const TicketState({
    this.ticketId = '',
    this.stationCount = '',
    this.encryptionKey = 'gUdeENpYlayCon56lgAzlVDtUBrvAndF',
    this.issueDate = '',
    this.expDate = '',
    this.qrData = '',
    this.isLoading = false,
    this.error,
    this.stations = const [],
    this.selectedStation,
    this.destinationStation,
  });

  TicketState copyWith({
    String? ticketId,
    String? stationCount,
    String? encryptionKey,
    String? issueDate,
    String? expDate,
    String? qrData,
    bool? isLoading,
    String? error,
    List<StationModel>? stations,
    StationModel? selectedStation,
    StationModel? destinationStation,
  }) {
    return TicketState(
      ticketId: ticketId ?? this.ticketId,
      stationCount: stationCount ?? this.stationCount,
      encryptionKey: encryptionKey ?? this.encryptionKey,
      issueDate: issueDate ?? this.issueDate,
      expDate: expDate ?? this.expDate,
      qrData: qrData ?? this.qrData,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      stations: stations ?? this.stations,
      selectedStation: selectedStation ?? this.selectedStation,
      destinationStation: destinationStation ?? this.destinationStation,
    );
  }
}

