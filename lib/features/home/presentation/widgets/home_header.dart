import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memora/core/theme/app-colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, $userName 👋',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 15.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),

        Container(
          height: 46.w,
          width: 46.w,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
            color: AppColors.textPrimary,
          ),
        ),

        SizedBox(width: 12.w),

        Container(
          height: 46.w,
          width: 46.w,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: const Icon(
            Icons.person_outline_rounded,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
