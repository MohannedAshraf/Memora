import 'package:equatable/equatable.dart';

class AlbumMemberEntity extends Equatable {
  final String userId;
  final String fullName;
  final String? avatarPath;
  final String role;
  final DateTime joinedAt;
  final String? email;

  const AlbumMemberEntity({
    required this.userId,
    required this.fullName,
    required this.avatarPath,
    required this.role,
    required this.joinedAt,
    this.email,
  });

  @override
  List<Object?> get props => [
    userId,
    fullName,
    avatarPath,
    role,
    joinedAt,
    email,
  ];
}
