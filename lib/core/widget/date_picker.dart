import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeTile extends StatefulWidget {
  final String title;

  const DateTimeTile({
    super.key,
    required this.title,
  });

  @override
  State<DateTimeTile> createState() => _DateTimeTileState();
}

class _DateTimeTileState extends State<DateTimeTile> {
  DateTime selectedDateTime = DateTime.now();

  Future<void> pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
    );

    if (time == null) return;

    setState(() {
      selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final formatted =
    DateFormat('dd/MM/yyyy HH:mm').format(selectedDateTime);

    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Text(
            "${widget.title}: ",
            style: const TextStyle(color: Colors.grey),
          ),

          Expanded(
            child: Text(
              formatted,
              style: const TextStyle(color: Colors.white),
            ),
          ),

          GestureDetector(
            onTap: pickDateTime,
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                "CHANGE",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}