import 'package:memora/features/albums/data/data_sources/album_members_remote_data_source.dart';

import '../../domain/entities/album_member_entity.dart';
import '../../domain/repo/album_members_repository.dart';

class AlbumMembersRepositoryImpl implements AlbumMembersRepository {
  final AlbumMembersRemoteDataSource remoteDataSource;

  AlbumMembersRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<AlbumMemberEntity>> getAlbumMembers(String albumId) {
    return remoteDataSource.getAlbumMembers(albumId);
  }

  @override
  Future<String?> getCurrentUserRole(String albumId) {
    return remoteDataSource.getCurrentUserRole(albumId);
  }
}
