import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/album_model.dart';

abstract class AlbumsRemoteDataSource {
  Future<List<AlbumModel>> getMyAlbums();

  Future<String> getCoverUrl(String? coverPhotoId);
}

class AlbumsRemoteDataSourceImpl implements AlbumsRemoteDataSource {
  final SupabaseClient client;

  AlbumsRemoteDataSourceImpl(this.client);

  @override
  Future<List<AlbumModel>> getMyAlbums() async {
    final user = client.auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    final response = await client
        .from('albums')
        .select()
        .eq('owner_id', user.id)
        .order('updated_at', ascending: false);

    return (response as List).map((json) => AlbumModel.fromJson(json)).toList();
  }

  @override
  Future<String> getCoverUrl(String? coverPhotoId) async {
    if (coverPhotoId == null) return '';

    final photo = await client
        .from('album_photos')
        .select('storage_path')
        .eq('id', coverPhotoId)
        .maybeSingle();

    if (photo == null) return '';

    final storagePath = photo['storage_path'] as String?;

    if (storagePath == null || storagePath.isEmpty) {
      return '';
    }

    /// غيّر اسم الـ Bucket لو عندك مختلف
    return client.storage.from('albums').getPublicUrl(storagePath);
  }
}
