import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:memora/features/auth/presentation/screens/widgest/login_footer.dart';
import 'package:memora/features/auth/presentation/screens/widgest/login_form.dart';
import 'package:memora/features/auth/presentation/screens/widgest/login_header.dart';



class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const LoginHeader(),

                  SizedBox(height: 45.h),

                  const LoginForm(),

                  SizedBox(height: 25.h),

                  LoginFooter(
                    onRegister: () {
                      context.push('/register');
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
