import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import '../core/widget/custom_drop_down.dart';
import '../core/widget/custom_text_field.dart';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController tkIdController = TextEditingController();
  final TextEditingController countController = TextEditingController();
  final TextEditingController keyController = TextEditingController();

  final Random _random = Random.secure();

  Station? selectedStation;
  String keyValue = "gUdeENpYlayCon56lgAzlVDtUBrvAndF";
  String qrData = "";
  String issueDate = "";
  String expDate = "";

  @override
  void initState() {
    super.initState();

    keyController.text = keyValue;

    final now = DateTime.now();
    issueDate = DateFormat('dd/MM/yyyy HH:mm').format(now);

    tkIdController.text = generateTicketId(now);
  }

  /// =========================
  /// RANDOM NUMBER (STRONG)
  /// =========================
  String generateRandomNumber(int length) {
    return List.generate(length, (_) => _random.nextInt(10)).join();
  }

  /// =========================
  /// GENERATE TICKET ID
  /// =========================
  String generateTicketId(DateTime dateTime) {
    final year = dateTime.year.toString().substring(2);
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0'); // ✅ جديد
    final randomPart = generateRandomNumber(8);
    return "$year$month$day$hour$minute$randomPart";
  }

  Station getDestinationStation(Station source, int count) {
    final targetOrder = source.order + count;

    return stations.firstWhere(
      (s) => s.order == targetOrder,
      orElse: () => source,
    );
  }

  String encryptData(Uint8List data, String keyString) {
    final key = encrypt.Key.fromUtf8(keyString);
    final iv = encrypt.IV.fromLength(16);

    final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.cbc),
    );

    final encrypted = encrypter.encryptBytes(data, iv: iv);

    return encrypted.base64;
  }

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

  String calculateExpDate(DateTime issue, int count) {
    final exp = issue.add(Duration(minutes: count * 30));
    return DateFormat('dd/MM/yyyy HH:mm').format(exp);
  }

  ///==========================
  /// LIST OF STATIONS
  ///==========================
  final List<Station> stations = [
    Station(id: 2085, name: "أكاديمية الشرطة", order: 1),
    Station(id: 2087, name: "طريق السويس", order: 2),
    Station(id: 2088, name: "عدلي منصور", order: 3),
    Station(id: 2089, name: "السلام", order: 4),
    Station(id: 2090, name: "الفريق إبراهيم العرابي", order: 5),
    Station(id: 2091, name: "مؤسسة الزكاة", order: 6),
    Station(id: 2092, name: "القلج", order: 7),
    Station(id: 2093, name: "المرج", order: 8),
    Station(id: 2094, name: "الخصوص", order: 9),
    Station(id: 2095, name: "مسطرد", order: 10),
    Station(id: 2096, name: "بهتيم", order: 11),
    Station(id: 2097, name: "شبرا بنها", order: 12),
    Station(id: 2098, name: "العقيد أحمد عبدالرحيم", order: 13),
    Station(id: 2099, name: "اسكندرية الزراعي", order: 14),
    Station(id: 2100, name: "باسوس", order: 15),
    Station(id: 2101, name: "الوراق", order: 16),
    Station(id: 2102, name: "تحيا مصر", order: 17),
    Station(id: 2103, name: "إمبابة", order: 18),
    Station(id: 2104, name: "محور أحمد عرابي", order: 19),
    Station(id: 2105, name: "أرض اللواء", order: 20),
    Station(id: 2106, name: "البراجيل", order: 21),
    Station(id: 2107, name: "محور 26 يوليو", order: 22),
    Station(id: 2108, name: "المعتمدية", order: 23),
    Station(id: 2109, name: "زينين", order: 24),
    Station(id: 2110, name: "صفط اللبن", order: 25),
    Station(id: 2111, name: "منشأة البكاري", order: 26),
    Station(id: 2112, name: "مسجد المدينة", order: 27),
    Station(id: 2113, name: "الملك فيصل", order: 28),
    Station(id: 2114, name: "الهرم", order: 29),
    Station(id: 2115, name: "ترسا", order: 30),
    Station(id: 2116, name: "المريوطية", order: 31),
    Station(id: 2117, name: "الطالبية", order: 32),
    Station(id: 2118, name: "العمرانية", order: 33),
    Station(id: 2119, name: "البحر الأعظم", order: 34),
    Station(id: 2120, name: "الزهراء", order: 35),
    Station(id: 2121, name: "الإمام الشافعي", order: 36),
    Station(id: 2122, name: "شارع الجزائر", order: 37),
    Station(id: 2123, name: "الأوتوستراد", order: 38),
    Station(id: 2124, name: "المقطم", order: 39),
    Station(id: 2125, name: "كارفور المعادي", order: 40),
    Station(id: 2126, name: "النساجون الشرقيون", order: 41),
    Station(id: 2127, name: "طريق السخنة", order: 42),
    Station(id: 2128, name: "الجولف", order: 43),
    Station(id: 2129, name: "المشير طنطاوي", order: 44),
  ];

  /// =========================
  /// DATE PICKER (FIXED SIZE)
  /// =========================
  Future<void> pickDate({required bool isIssue}) async {
    DateTime now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Transform.scale(scale: 0.9, child: child);
      },
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Transform.scale(scale: 0.9, child: child);
      },
    );

    if (time == null) return;

    final finalDate = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    final formatted = DateFormat('dd/MM/yyyy HH:mm').format(finalDate);

    setState(() {
      if (isIssue) {
        issueDate = formatted;

        // ✅ يتولد كل مرة
        tkIdController.text = generateTicketId(finalDate);
      } else {
        expDate = formatted;
      }
    });
  }

  /// =========================
  /// GENERATE QR
  /// =========================

  void generateQR() {
    if (selectedStation == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("اختار محطة الأول")));
      return;
    }

    if (tkIdController.text.isEmpty ||
        countController.text.isEmpty ||
        keyController.text.isEmpty ||
        issueDate.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("من فضلك املأ كل الحقول")));
      return;
    }

    final count = int.tryParse(countController.text);
    if (count == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("عدد المحطات غير صالح")));
      return;
    }

    final issueDateTime = DateFormat('dd/MM/yyyy HH:mm').parse(issueDate);

    expDate = calculateExpDate(issueDateTime, count);

    final ticketNumber = int.parse(tkIdController.text);

    final destination = getDestinationStation(selectedStation!, count);

    final bytes = generateQrBytes(
      ticketNumber: ticketNumber,
      stationCount: count,
      sourceId: selectedStation!.id,
      destinationId: destination.id,
    );

    setState(() {
      final encrypted = encryptData(bytes, keyController.text);

      setState(() {
        qrData = encrypted;
      });
    });
  }

  @override
  void dispose() {
    tkIdController.dispose();
    countController.dispose();
    keyController.dispose();
    super.dispose();
  }

  /// =========================
  /// UI
  /// =========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1C1C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "تذكرة النقل",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// DATE TILES
            Row(
              children: [
                Expanded(
                  child: _modernDateTile(
                    "تاريخ الإصدار",
                    issueDate.isEmpty ? "--/--/---- --:--" : issueDate,
                    () => pickDate(isIssue: true),
                  ),
                ),
                Gap(12.w),
              ],
            ),

            Gap(32.h),

            /// INPUTS
            CustomTextField(
              label: "رقم التذكرة (Tk. ID)",
              hint: "أدخل رقم التذكرة",
              controller: tkIdController,
            ),

            Gap(16.h),

            CustomDropdown(
              label: "المحطة (St. ID)",
              items: stations.map((e) => "${e.id} - ${e.name}").toList(),
              onChanged: (value) {
                final station = stations.firstWhere(
                  (e) => "${e.id} - ${e.name}" == value,
                );
                setState(() {
                  selectedStation = station;
                });
              },
            ),

            Gap(16.h),

            CustomTextField(
              label: "عدد المحطات (Count)",
              hint: "أدخل العدد",
              controller: countController,
              keyboardType: TextInputType.number,
            ),

            Gap(16.h),

            CustomTextField(
              label: "المفتاح (Key)",
              hint: "أدخل المفتاح...",
              controller: keyController,
              onChanged: (value) {
                keyValue = value;
              },
            ),

            Gap(32.h),

            /// BUTTON
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: generateQR,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF427292),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: const Text(
                  "توليد الـ QR",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            Gap(40.h),

            /// 🎫 MODERN QR TICKET
            if (qrData.isNotEmpty)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    /// HEADER
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 18.h),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF427292), Color(0xFF376787)],
                        ),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24.r),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "وزارة النقل",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Gap(4.h),
                          Text(
                            "تذكرة إلكترونية",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                        children: [
                          /// QR
                          Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: PrettyQrView.data(
                              data: qrData,
                              decoration: const PrettyQrDecoration(
                                shape: PrettyQrSmoothSymbol(
                                  color: Colors.black, // ✅ BLACK QR
                                ),
                              ),
                            ),
                          ),

                          Gap(20.h),

                          Row(
                            children: [
                              Expanded(child: Divider()),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                child: Icon(
                                  Icons.confirmation_number,
                                  color: Colors.grey,
                                ),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),

                          Gap(16.h),

                          _ticketDetailRow("رقم التذكرة", tkIdController.text),
                          _ticketDetailRow(
                            "المحطة",
                            selectedStation != null
                                ? "${selectedStation!.id} - ${selectedStation!.name}"
                                : "-",
                          ),
                          _ticketDetailRow("عدد المحطات", countController.text),
                          _ticketDetailRow("تاريخ الإصدار", issueDate),
                          _ticketDetailRow("صالح حتى", expDate),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// =========================
  /// WIDGETS
  /// =========================
  Widget _modernDateTile(String title, String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: const Color(0xFF427292).withOpacity(0.08),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFF427292).withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 12.sp, color: const Color(0xFF427292)),
            ),
            Gap(4.h),
            Text(
              value,
              style: TextStyle(fontSize: 15.sp, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ticketDetailRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
          const Spacer(),
          Text(
            value.isEmpty ? "-" : value,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class Station {
  final int id;
  final String name;
  final int order;

  Station({required this.id, required this.name, required this.order});
}
