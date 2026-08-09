import 'package:memora/features/albums/data/data_sources/album_media_remote_data_source.dart';

import '../../domain/entities/album_media_entity.dart';
import '../../domain/repo/album_media_repository.dart';

class AlbumMediaRepositoryImpl implements AlbumMediaRepository {
  final AlbumMediaRemoteDataSource remoteDataSource;

  AlbumMediaRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<AlbumMediaEntity>> getAlbumMedia(String albumId) {
    return remoteDataSource.getAlbumMedia(albumId);
  }
}
