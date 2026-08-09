import 'package:memora/features/profile/data/data_sources/profile_remote_data_source.dart';
import 'package:memora/features/profile/domain/repo/profile_repository.dart';

import '../../domain/entities/profile_entity.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<ProfileEntity> getProfile() {
    return remoteDataSource.getProfile();
  }

  @override
  Future<ProfileEntity> updateProfile({
    required String fullName,
    String? avatarPath,
  }) {
    return remoteDataSource.updateProfile(
      fullName: fullName,
      avatarPath: avatarPath,
    );
  }

  @override
  Future<String> uploadAvatar(String filePath) {
    return remoteDataSource.uploadAvatar(filePath);
  }
}
