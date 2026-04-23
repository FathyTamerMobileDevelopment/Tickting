part of 'ticket_cubit.dart';

abstract class TicketEvent {}

class InitializeTicketEvent extends TicketEvent {}

class UpdateTicketIdEvent extends TicketEvent {
  final String id;
  UpdateTicketIdEvent(this.id);
}

class UpdateStationCountEvent extends TicketEvent {
  final String count;
  UpdateStationCountEvent(this.count);
}

class UpdateEncryptionKeyEvent extends TicketEvent {
  final String key;
  UpdateEncryptionKeyEvent(this.key);
}

class SelectStationEvent extends TicketEvent {
  final StationModel station;
  SelectStationEvent(this.station);
}

class UpdateIssueDateEvent extends TicketEvent {
  final String date;
  UpdateIssueDateEvent(this.date);
}

class GenerateQREvent extends TicketEvent {}

