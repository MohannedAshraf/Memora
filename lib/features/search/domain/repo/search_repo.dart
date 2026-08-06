import '../entities/search_album_entity.dart';

abstract class SearchRepository {
  Future<List<SearchAlbumEntity>> searchAlbums(String query);
}
