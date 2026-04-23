class TicketModel {
  final int ticketNumber;
  final int stationCount;
  final int sourceId;
  final int destinationId;
  final String issueDate;
  final String expDate;
  final String qrData;

  TicketModel({
    required this.ticketNumber,
    required this.stationCount,
    required this.sourceId,
    required this.destinationId,
    required this.issueDate,
    required this.expDate,
    required this.qrData,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      ticketNumber: json['ticketNumber'] as int,
      stationCount: json['stationCount'] as int,
      sourceId: json['sourceId'] as int,
      destinationId: json['destinationId'] as int,
      issueDate: json['issueDate'] as String,
      expDate: json['expDate'] as String,
      qrData: json['qrData'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticketNumber': ticketNumber,
      'stationCount': stationCount,
      'sourceId': sourceId,
      'destinationId': destinationId,
      'issueDate': issueDate,
      'expDate': expDate,
      'qrData': qrData,
    };
  }
}

