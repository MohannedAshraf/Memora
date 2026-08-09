import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String? avatarPath;

  const ProfileEntity({
    required this.id,
    required this.fullName,
    required this.email,
    this.avatarPath,
  });

  @override
  List<Object?> get props => [id, fullName, email, avatarPath];
}
