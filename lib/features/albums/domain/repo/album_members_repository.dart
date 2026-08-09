import '../entities/album_member_entity.dart';

abstract class AlbumMembersRepository {
  Future<List<AlbumMemberEntity>> getAlbumMembers(String albumId);

  Future<String?> getCurrentUserRole(String albumId);
}
