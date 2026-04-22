import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final Function(String)? onChanged; // ✅

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.prefixIcon,
    this.keyboardType,
    this.onChanged, // ✅
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2B2B),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            onChanged: onChanged,
             style: TextStyle(color: Colors.white, fontSize: 14.sp),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.white54, fontSize: 13.sp),
              prefixIcon: prefixIcon,
              border: InputBorder.none,
            ),
          ),
        ),
        SizedBox(height: 4.h),
      ],
    );
  }
}
