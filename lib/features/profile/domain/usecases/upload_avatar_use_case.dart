import 'package:memora/features/profile/domain/repo/profile_repository.dart';


class UploadAvatarUseCase {
  final ProfileRepository repository;

  UploadAvatarUseCase(this.repository);

  Future<String> call(String filePath) {
    return repository.uploadAvatar(filePath);
  }
}
