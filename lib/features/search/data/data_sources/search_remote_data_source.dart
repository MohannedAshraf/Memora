import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/search_album_model.dart';

abstract class SearchRemoteDataSource {
  Future<List<SearchAlbumModel>> searchAlbums(String query);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final SupabaseClient client;

  SearchRemoteDataSourceImpl(this.client);

  @override
  Future<List<SearchAlbumModel>> searchAlbums(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    final response = await client.rpc(
      "search_albums",
      params: {"search_text": query},
    );

    return (response as List).map((e) => SearchAlbumModel.fromJson(e)).toList();
  }
}
