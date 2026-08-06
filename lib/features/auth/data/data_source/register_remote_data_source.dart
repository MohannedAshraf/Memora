import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/register_model.dart';

abstract class RegisterRemoteDataSource {
  Future<void> register(RegisterModel model);
}

class RegisterRemoteDataSourceImpl implements RegisterRemoteDataSource {
  final SupabaseClient client;

  RegisterRemoteDataSourceImpl(this.client);

  @override
  Future<void> register(RegisterModel model) async {
    await client.auth.signUp(
      email: model.email,
      password: model.password,
      data: {
        "full_name": model.fullName,
        "phone": model.phone,
        "email": model.email, // مهم
      },
    );
  }
}
