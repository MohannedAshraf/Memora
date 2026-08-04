import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memora/core/theme/app-colors.dart';


class LoginFooter extends StatelessWidget {
  final VoidCallback onRegister;

  const LoginFooter({super.key, required this.onRegister});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?",
          style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
        ),
        TextButton(
          onPressed: onRegister,
          child: Text(
            'Register',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
