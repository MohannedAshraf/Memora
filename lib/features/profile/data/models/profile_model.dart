import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.fullName,
    required super.email,
    super.avatarPath,
  });

  factory ProfileModel.fromJson(
    Map<String, dynamic> json, {
    required String email,
  }) {
    return ProfileModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String? ?? '',
      email: email,
      avatarPath: json['avatar_path'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'full_name': fullName, 'avatar_path': avatarPath};
  }
}
