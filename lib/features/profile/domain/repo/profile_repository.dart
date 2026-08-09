import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<ProfileEntity> getProfile();

  Future<ProfileEntity> updateProfile({
    required String fullName,
    String? avatarPath,
  });

  Future<String> uploadAvatar(String filePath);
}
