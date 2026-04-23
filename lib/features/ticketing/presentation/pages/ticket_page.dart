import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import '../../../../core/widget/custom_drop_down.dart';
import '../../../../core/widget/custom_text_field.dart';
import '../cubits/ticket_cubit.dart';


class TicketPage extends StatefulWidget {
  const TicketPage({super.key});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  late TextEditingController tkIdController;
  late TextEditingController countController;
  late TextEditingController keyController;

  @override
  void initState() {
    super.initState();
    tkIdController = TextEditingController();
    countController = TextEditingController();
    keyController = TextEditingController();

    context.read<TicketCubit>().initializeTicket();
  }

  @override
  void dispose() {
    tkIdController.dispose();
    countController.dispose();
    keyController.dispose();
    super.dispose();
  }

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
      body: BlocBuilder<TicketCubit, TicketState>(
        builder: (context, state) {
          if (state.stations.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          tkIdController.text = state.ticketId;
          countController.text = state.stationCount;
          keyController.text = state.encryptionKey;

          return SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _modernDateTile(
                        "تاريخ الإصدار",
                        state.issueDate.isEmpty
                            ? "--/--/---- --:--"
                            : state.issueDate,
                        () => _pickDate(context, true),
                      ),
                    ),
                    Gap(12.w),
                  ],
                ),
                Gap(32.h),
                CustomTextField(
                  label: "رقم التذكرة (Tk. ID)",
                  hint: "أدخل رقم التذكرة",
                  controller: tkIdController,
                  onChanged: (value) {
                    context.read<TicketCubit>().updateTicketId(value);
                  },
                ),
                Gap(16.h),
                CustomDropdown(
                  label: "المحطة (St. ID)",
                  items: state.stations
                      .map((e) => "${e.id} - ${e.name}")
                      .toList(),
                  onChanged: (value) {
                    final station = state.stations.firstWhere(
                      (e) => "${e.id} - ${e.name}" == value,
                    );
                    context.read<TicketCubit>().selectStation(station);
                  },
                ),
                Gap(16.h),
                CustomTextField(
                  label: "عدد المحطات (Count)",
                  hint: "أدخل العدد",
                  controller: countController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    context.read<TicketCubit>().updateStationCount(value);
                  },
                ),
                Gap(16.h),
                CustomTextField(
                  label: "المفتاح (Key)",
                  hint: "أدخل المفتاح...",
                  controller: keyController,
                  onChanged: (value) {
                    context.read<TicketCubit>().updateEncryptionKey(value);
                  },
                ),
                Gap(32.h),
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: state.isLoading
                        ? null
                        : () {
                            context.read<TicketCubit>().generateQR();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF427292),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    child: state.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : const Text(
                            "توليد الـ QR",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                if (state.error != null)
                  Padding(
                    padding: EdgeInsets.only(top: 16.h),
                    child: Text(
                      state.error!,
                      style: TextStyle(color: Colors.red, fontSize: 14.sp),
                    ),
                  ),
                Gap(40.h),
                if (state.qrData.isNotEmpty) _buildTicketCard(state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTicketCard(TicketState state) {
    return Container(
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
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: PrettyQrView.data(
                    data: state.qrData,
                    decoration: const PrettyQrDecoration(
                      shape: PrettyQrSmoothSymbol(
                        color: Colors.black,
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
                _ticketDetailRow("رقم التذكرة", state.ticketId),
                _ticketDetailRow(
                  "المحطة",
                  state.selectedStation != null
                      ? "${state.selectedStation!.id} - ${state.selectedStation!.name}"
                      : "-",
                ),
                _ticketDetailRow("عدد المحطات", state.stationCount),
                _ticketDetailRow("تاريخ الإصدار", state.issueDate),
                _ticketDetailRow("صالح حتى", state.expDate),
              ],
            ),
          ),
        ],
      ),
    );
  }

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

  Future<void> _pickDate(BuildContext context, bool isIssue) async {
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

    if (isIssue) {
      context.read<TicketCubit>().updateIssueDate(formatted);
    }
  }
}

