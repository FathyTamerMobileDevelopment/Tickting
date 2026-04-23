import 'dart:math';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import '../../domain/models/station_model.dart';

abstract class TicketRepository {
  String generateRandomNumber(int length);
  String generateTicketId(DateTime dateTime);
  StationModel getDestinationStation(StationModel source, int count);
  Uint8List generateQrBytes({
    required int ticketNumber,
    required int stationCount,
    required int sourceId,
    required int destinationId,
  });
  String calculateExpDate(DateTime issue, int count);
  List<StationModel> getStations();
}

class TicketRepositoryImpl implements TicketRepository {
  final Random _random = Random.secure();

  @override
  String generateRandomNumber(int length) {
    return List.generate(length, (_) => _random.nextInt(10)).join();
  }

  @override
  String generateTicketId(DateTime dateTime) {
    final year = dateTime.year.toString().substring(2);
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final randomPart = generateRandomNumber(8);
    return "$year$month$day$hour$minute$randomPart";
  }

  @override
  StationModel getDestinationStation(StationModel source, int count) {
    final targetOrder = source.order + count;
    return getStations().firstWhere(
      (s) => s.order == targetOrder,
      orElse: () => source,
    );
  }

  @override
  Uint8List generateQrBytes({
    required int ticketNumber,
    required int stationCount,
    required int sourceId,
    required int destinationId,
  }) {
    final bytes = ByteData(14);
    bytes.setUint64(0, ticketNumber, Endian.little);
    bytes.setUint16(8, stationCount, Endian.little);
    bytes.setUint16(10, sourceId, Endian.little);
    bytes.setUint16(12, destinationId, Endian.little);
    return bytes.buffer.asUint8List();
  }

  @override
  String calculateExpDate(DateTime issue, int count) {
    final exp = issue.add(Duration(minutes: count * 30));
    return DateFormat('dd/MM/yyyy HH:mm').format(exp);
  }

  @override
  List<StationModel> getStations() {
    return [
      StationModel(id: 2085, name: "أكاديمية الشرطة", order: 1),
      StationModel(id: 2087, name: "طريق السويس", order: 2),
      StationModel(id: 2088, name: "عدلي منصور", order: 3),
      StationModel(id: 2089, name: "السلام", order: 4),
      StationModel(id: 2090, name: "الفريق إبراهيم العرابي", order: 5),
      StationModel(id: 2091, name: "مؤسسة الزكاة", order: 6),
      StationModel(id: 2092, name: "القلج", order: 7),
      StationModel(id: 2093, name: "المرج", order: 8),
      StationModel(id: 2094, name: "الخصوص", order: 9),
      StationModel(id: 2095, name: "مسطرد", order: 10),
      StationModel(id: 2096, name: "بهتيم", order: 11),
      StationModel(id: 2097, name: "شبرا بنها", order: 12),
      StationModel(id: 2098, name: "العقيل أحمد عبدالرحيم", order: 13),
      StationModel(id: 2099, name: "اسكندرية الزراعي", order: 14),
      StationModel(id: 2100, name: "باسوس", order: 15),
      StationModel(id: 2101, name: "الوراق", order: 16),
      StationModel(id: 2102, name: "تحيا مصر", order: 17),
      StationModel(id: 2103, name: "إمبابة", order: 18),
      StationModel(id: 2104, name: "محور أحمد عرابي", order: 19),
      StationModel(id: 2105, name: "أرض اللواء", order: 20),
      StationModel(id: 2106, name: "البراجيل", order: 21),
      StationModel(id: 2107, name: "محور 26 يوليو", order: 22),
      StationModel(id: 2108, name: "المعتمدية", order: 23),
      StationModel(id: 2109, name: "زينين", order: 24),
      StationModel(id: 2110, name: "صفط اللبن", order: 25),
      StationModel(id: 2111, name: "منشأة البكاري", order: 26),
      StationModel(id: 2112, name: "مسجد المدينة", order: 27),
      StationModel(id: 2113, name: "الملك فيصل", order: 28),
      StationModel(id: 2114, name: "الهرم", order: 29),
      StationModel(id: 2115, name: "ترسا", order: 30),
      StationModel(id: 2116, name: "المريوطية", order: 31),
      StationModel(id: 2117, name: "الطالبية", order: 32),
      StationModel(id: 2118, name: "العمرانية", order: 33),
      StationModel(id: 2119, name: "البحر الأعظم", order: 34),
      StationModel(id: 2120, name: "الزهراء", order: 35),
      StationModel(id: 2121, name: "الإمام الشافعي", order: 36),
      StationModel(id: 2122, name: "شارع الجزائر", order: 37),
      StationModel(id: 2123, name: "الأوتوستراد", order: 38),
      StationModel(id: 2124, name: "المقطم", order: 39),
      StationModel(id: 2125, name: "كارفور المعادي", order: 40),
      StationModel(id: 2126, name: "النساجون الشرقيون", order: 41),
      StationModel(id: 2127, name: "طريق السخنة", order: 42),
      StationModel(id: 2128, name: "الجولف", order: 43),
      StationModel(id: 2129, name: "المشير طنطاوي", order: 44),
    ];
  }
}


