import '../entities/album_member_entity.dart';
import '../repo/album_members_repository.dart';

class GetAlbumMembersUseCase {
  final AlbumMembersRepository repository;

  GetAlbumMembersUseCase(this.repository);

  Future<List<AlbumMemberEntity>> call(String albumId) {
    return repository.getAlbumMembers(albumId);
  }

  Future<String?> getCurrentUserRole(String albumId) {
    return repository.getCurrentUserRole(albumId);
  }
}
