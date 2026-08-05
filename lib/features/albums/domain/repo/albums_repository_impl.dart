import 'package:memora/features/albums/data/data_sources/albums_remote_data_source.dart';
import 'package:memora/features/albums/domain/repo/albums_repository.dart';

import '../../domain/entities/album_entity.dart';


class AlbumsRepositoryImpl implements AlbumsRepository {
  final AlbumsRemoteDataSource remoteDataSource;

  AlbumsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<AlbumEntity>> getMyAlbums() {
    return remoteDataSource.getMyAlbums();
  }
}
