import 'package:memora/features/albums/data/data_sources/album_details_remote_data_source.dart';

import '../../domain/entities/album_details_entity.dart';
import '../../domain/repo/album_details_repository.dart';

class AlbumDetailsRepositoryImpl implements AlbumDetailsRepository {
  final AlbumDetailsRemoteDataSource remoteDataSource;

  AlbumDetailsRepositoryImpl(this.remoteDataSource);

  @override
  Future<AlbumDetailsEntity> getAlbumDetails(String albumId) {
    return remoteDataSource.getAlbumDetails(albumId);
  }

  @override
  Future<String> getCoverUrl(String? coverPhotoId) {
    return remoteDataSource.getCoverUrl(coverPhotoId);
  }
}
