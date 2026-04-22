import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final String label;
  final List<String> items;
  final Function(String?)? onChanged;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.items,
    this.onChanged,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.items.first;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: selectedValue,
          dropdownColor: Colors.black87,
          style: const TextStyle(color: Colors.white),
          iconEnabledColor: Colors.white,
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
          items: widget.items
              .map((item) => DropdownMenuItem(
            value: item,
            child: Text(item),
          ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedValue = value;
            });
            widget.onChanged?.call(value);
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}