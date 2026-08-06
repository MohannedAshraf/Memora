import 'package:memora/features/search/data/data_sources/search_remote_data_source.dart';
import 'package:memora/features/search/domain/repo/search_repo.dart';

import '../../domain/entities/search_album_entity.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remote;

  SearchRepositoryImpl(this.remote);

  @override
  Future<List<SearchAlbumEntity>> searchAlbums(String query) {
    return remote.searchAlbums(query);
  }
}
