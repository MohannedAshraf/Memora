import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memora/core/constants/app_images.dart';
import 'package:memora/core/theme/app-colors.dart';



class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(AppImages.logo, width: 130.w),
        SizedBox(height: 30.h),
        Text(
          'Create Account',
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Create your account to continue',
          style: TextStyle(fontSize: 15.sp, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
