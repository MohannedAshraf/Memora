import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/album_media_model.dart';

abstract class AlbumMediaRemoteDataSource {
  Future<List<AlbumMediaModel>> getAlbumMedia(String albumId);
}

class AlbumMediaRemoteDataSourceImpl implements AlbumMediaRemoteDataSource {
  final SupabaseClient client;

  AlbumMediaRemoteDataSourceImpl(this.client);

  @override
  Future<List<AlbumMediaModel>> getAlbumMedia(String albumId) async {
    final response = await client
        .from('album_photos')
        .select('id, album_id, uploaded_by, storage_path, caption, created_at')
        .eq('album_id', albumId)
        .order('created_at', ascending: false);

    return (response as List).map((json) {
      final data = Map<String, dynamic>.from(json);

      final storagePath = data['storage_path'] as String;

      final url = client.storage.from('album-photos').getPublicUrl(storagePath);

      return AlbumMediaModel.fromJson(json: data, url: url);
    }).toList();
  }
}
