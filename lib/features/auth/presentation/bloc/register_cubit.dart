import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/register_entity.dart';
import '../../domain/usecases/register_usecase.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterCubit(this.registerUseCase) : super(RegisterInitial());

  Future<void> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    emit(RegisterLoading());

    try {
      await registerUseCase(
        RegisterEntity(
          fullName: fullName.trim(),
          email: email.trim(),
          phone: phone.trim(),
          password: password.trim(),
        ),
      );

      emit(RegisterSuccess());
    } on AuthException catch (e) {
      emit(RegisterFailure(e.message));
    } catch (_) {
      emit(const RegisterFailure("Something went wrong"));
    }
  }
}
