import '../../domain/entities/album_member_entity.dart';

class AlbumMemberModel extends AlbumMemberEntity {
  const AlbumMemberModel({
    required super.userId,
    required super.fullName,
    required super.avatarPath,
    required super.role,
    required super.joinedAt,
    super.email,
  });

  factory AlbumMemberModel.fromJson(Map<String, dynamic> json) {
    final profile = json['profiles'] as Map<String, dynamic>?;

    return AlbumMemberModel(
      userId: json['user_id'] as String,
      fullName: profile?['full_name'] as String? ?? 'User',
      avatarPath: profile?['avatar_path'] as String?,
      role: json['role'] as String,
      joinedAt: DateTime.parse(json['joined_at'] as String),
      email: profile?['email'] as String?,
    );
  }
}
