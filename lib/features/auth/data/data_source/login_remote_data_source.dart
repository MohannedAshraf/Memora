import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/login_model.dart';

abstract class LoginRemoteDataSource {
  Future<void> login(LoginModel model);
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final SupabaseClient client;

  LoginRemoteDataSourceImpl(this.client);

  @override
  Future<void> login(LoginModel model) async {
    await client.auth.signInWithPassword(
      email: model.email,
      password: model.password,
    );
  }
}
