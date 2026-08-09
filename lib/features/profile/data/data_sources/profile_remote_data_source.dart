// ignore_for_file: use_null_aware_elements

import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/profile_model.dart';
abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();

  Future<ProfileModel> updateProfile({
    required String fullName,
    String? avatarPath,
  });

  Future<String> uploadAvatar(String filePath);
}
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient client;

  ProfileRemoteDataSourceImpl(this.client);

  @override
  Future<ProfileModel> getProfile() async {
    final user = client.auth.currentUser;

    if (user == null) {
      throw Exception('User is not authenticated');
    }

    final data = await client
        .from('profiles')
        .select('id, full_name, avatar_path')
        .eq('id', user.id)
        .single();

    return ProfileModel.fromJson(data, email: user.email ?? '');
  }

  @override
  Future<String> uploadAvatar(String filePath) async {
    final user = client.auth.currentUser;

    if (user == null) {
      throw Exception('User is not authenticated');
    }

    final file = File(filePath);

    final extension = filePath.split('.').last.toLowerCase();

    final path = 'avatars/${user.id}.$extension';

    await client.storage
        .from('album-photos')
        .upload(path, file, fileOptions: const FileOptions(upsert: true));

    return path;
  }

  @override
  Future<ProfileModel> updateProfile({
    required String fullName,
    String? avatarPath,
  }) async {
    final user = client.auth.currentUser;

    if (user == null) {
      throw Exception('User is not authenticated');
    }

    final data = await client
        .from('profiles')
        .update({
          'full_name': fullName,
          if (avatarPath != null) 'avatar_path': avatarPath,
        })
        .eq('id', user.id)
        .select('id, full_name, avatar_path')
        .single();

    return ProfileModel.fromJson(data, email: user.email ?? '');
  }
}
