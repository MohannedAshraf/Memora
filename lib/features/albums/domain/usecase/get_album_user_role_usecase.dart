import '../repo/album_members_repository.dart';

class GetAlbumUserRoleUseCase {
  final AlbumMembersRepository repository;

  GetAlbumUserRoleUseCase(this.repository);

  Future<String?> call(String albumId) {
    return repository.getCurrentUserRole(albumId);
  }
}
