import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:memora/features/auth/presentation/screens/widgest/register_footer.dart';
import 'package:memora/features/auth/presentation/screens/widgest/register_form.dart';
import 'package:memora/features/auth/presentation/screens/widgest/register_header.dart';

import '../../../../core/di/injection.dart';
import '../bloc/register_cubit.dart';


class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RegisterCubit>(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const RegisterHeader(),

                    SizedBox(height: 40.h),

                    const RegisterForm(),

                    SizedBox(height: 25.h),

                    RegisterFooter(
                      onLogin: () {
                      context.go('/login');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
