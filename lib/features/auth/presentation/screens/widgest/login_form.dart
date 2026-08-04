import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:memora/core/utils/validators.dart';
import 'package:memora/core/widgets/app_button.dart';
import 'package:memora/core/widgets/app_snackbar.dart';
import 'package:memora/core/widgets/app_text_field.dart';
import 'package:memora/features/auth/presentation/bloc/login_cubit.dart';
import 'package:memora/features/auth/presentation/bloc/login_state.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscure = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
         context.go('/home');
        }

        if (state is LoginFailure) {
         AppSnackbar.error(context, state.message);
        }
      },
      builder: (context, state) {
        return Form(
          key: formKey,
          child: Column(
            children: [
              AppTextField(
                controller: emailController,
                hintText: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: Validators.validateEmail,
              ),

              SizedBox(height: 18.h),

              AppTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: obscure,
                validator: Validators.validatePassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscure = !obscure;
                    });
                  },
                  icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
                ),
              ),

              SizedBox(height: 30.h),

              AppButton(
                text: 'Login',
                isLoading: state is LoginLoading,
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    context.read<LoginCubit>().login(
                      email: emailController.text.trim(),
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
