import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/album_details_model.dart';

abstract class AlbumDetailsRemoteDataSource {
  Future<AlbumDetailsModel> getAlbumDetails(String albumId);

  Future<String> getCoverUrl(String? coverPhotoId);
}

class AlbumDetailsRemoteDataSourceImpl implements AlbumDetailsRemoteDataSource {
  final SupabaseClient client;

  AlbumDetailsRemoteDataSourceImpl(this.client);

  @override
  Future<AlbumDetailsModel> getAlbumDetails(String albumId) async {
    final response = await client
        .from('albums')
        .select(
          'id, title, description, cover_photo_id, created_at, updated_at',
        )
        .eq('id', albumId)
        .maybeSingle();

    if (response == null) {
      throw Exception('Album not found');
    }

    return AlbumDetailsModel.fromJson(response);
  }

  @override
  Future<String> getCoverUrl(String? coverPhotoId) async {
    if (coverPhotoId == null || coverPhotoId.isEmpty) {
      return '';
    }

    final photo = await client
        .from('album_photos')
        .select('storage_path')
        .eq('id', coverPhotoId)
        .maybeSingle();

    if (photo == null) {
      return '';
    }

    final storagePath = photo['storage_path'] as String?;

    if (storagePath == null || storagePath.isEmpty) {
      return '';
    }

    return client.storage.from('album-photos').getPublicUrl(storagePath);
  }
}
