import 'package:memora/features/profile/domain/repo/profile_repository.dart';

import '../entities/profile_entity.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<ProfileEntity> call() {
    return repository.getProfile();
  }
}
