import 'package:memora/features/profile/domain/repo/profile_repository.dart';

import '../entities/profile_entity.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<ProfileEntity> call({required String fullName, String? avatarPath}) {
    return repository.updateProfile(fullName: fullName, avatarPath: avatarPath);
  }
}
