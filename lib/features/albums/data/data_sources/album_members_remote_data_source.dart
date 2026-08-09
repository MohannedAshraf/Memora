import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/album_member_model.dart';

abstract class AlbumMembersRemoteDataSource {
  Future<List<AlbumMemberModel>> getAlbumMembers(String albumId);

  Future<String?> getCurrentUserRole(String albumId);
}

class AlbumMembersRemoteDataSourceImpl implements AlbumMembersRemoteDataSource {
  final SupabaseClient client;

  AlbumMembersRemoteDataSourceImpl(this.client);

  @override
  Future<List<AlbumMemberModel>> getAlbumMembers(String albumId) async {
    final response = await client
        .from('album_members')
        .select('''
          user_id,
          role,
          joined_at,
          profiles (
            id,
            full_name,
            avatar_path,
            email
          )
          ''')
        .eq('album_id', albumId)
        .order('joined_at', ascending: true);

    return (response as List)
        .map(
          (json) => AlbumMemberModel.fromJson(Map<String, dynamic>.from(json)),
        )
        .toList();
  }

  @override
  Future<String?> getCurrentUserRole(String albumId) async {
    final user = client.auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final response = await client
        .from('album_members')
        .select('role')
        .eq('album_id', albumId)
        .eq('user_id', user.id)
        .maybeSingle();

    return response?['role'] as String?;
  }
}
