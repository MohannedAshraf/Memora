import 'package:memora/features/search/domain/repo/search_repo.dart';

import '../entities/search_album_entity.dart';

class SearchAlbumsUseCase {
  final SearchRepository repository;

  SearchAlbumsUseCase(this.repository);

  Future<List<SearchAlbumEntity>> call(String query) {
    return repository.searchAlbums(query);
  }
}
