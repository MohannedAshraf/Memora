import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:memora/core/utils/validators.dart';
import 'package:memora/core/widgets/app_button.dart';
import 'package:memora/core/widgets/app_snackbar.dart';
import 'package:memora/core/widgets/app_text_field.dart';
import 'package:memora/features/auth/presentation/bloc/register_cubit.dart';
import 'package:memora/features/auth/presentation/bloc/register_state.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirm = true;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          context.go('/home');
        }

        if (state is RegisterFailure) {
          AppSnackbar.error(context, state.message);
        }
      },
      builder: (context, state) {
        return Form(
          key: formKey,
          child: Column(
            children: [
              AppTextField(
                controller: fullNameController,
                hintText: 'Full Name',
                validator: Validators.validateName,
              ),

              SizedBox(height: 16.h),

              AppTextField(
                controller: emailController,
                hintText: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: Validators.validateEmail,
              ),

              SizedBox(height: 16.h),

              AppTextField(
                controller: phoneController,
                hintText: 'Phone Number',
                keyboardType: TextInputType.phone,
                validator: Validators.validatePhone,
              ),

              SizedBox(height: 16.h),

              AppTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: obscurePassword,
                validator: Validators.validatePassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                  icon: Icon(
                    obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              AppTextField(
                controller: confirmController,
                hintText: 'Confirm Password',
                obscureText: obscureConfirm,
                validator: (value) {
                  return Validators.validateConfirmPassword(
                    value,
                    passwordController.text,
                  );
                },
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscureConfirm = !obscureConfirm;
                    });
                  },
                  icon: Icon(
                    obscureConfirm ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),

              SizedBox(height: 28.h),

              AppButton(
                text: 'Register',
                isLoading: state is RegisterLoading,
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    context.read<RegisterCubit>().register(
                      fullName: fullNameController.text.trim(),
                      email: emailController.text.trim(),
                      phone: phoneController.text.trim(),
                      password: passwordController.text,
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
