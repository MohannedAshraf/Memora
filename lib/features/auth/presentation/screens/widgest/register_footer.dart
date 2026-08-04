import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memora/core/theme/app-colors.dart';


class RegisterFooter extends StatelessWidget {
  final VoidCallback onLogin;

  const RegisterFooter({super.key, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account?',
          style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
        ),
        TextButton(
          onPressed: onLogin,
          child: Text(
            'Login',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
