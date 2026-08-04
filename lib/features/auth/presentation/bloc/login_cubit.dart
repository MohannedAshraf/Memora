import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/login_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginCubit(this.loginUseCase) : super(LoginInitial());

  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());

    try {
      await loginUseCase(
        LoginEntity(email: email.trim(), password: password.trim()),
      );

      emit(LoginSuccess());
    } on AuthException catch (e) {
      emit(LoginFailure(e.message));
    } catch (_) {
      emit(const LoginFailure('Something went wrong'));
    }
  }
}
