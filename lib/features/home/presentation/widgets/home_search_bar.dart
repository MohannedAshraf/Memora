import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memora/core/theme/app-colors.dart';


class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key, this.onChanged});

  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search albums...',
        prefixIcon: const Icon(Icons.search_rounded),

        filled: true,
        fillColor: AppColors.surface,

        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}
