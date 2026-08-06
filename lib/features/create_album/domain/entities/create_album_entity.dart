import 'dart:io';

import 'package:equatable/equatable.dart';

import 'album_invitation_entity.dart';

class CreateAlbumEntity extends Equatable {
  final String title;
  final String description;
  final File? coverImage;

  final List<AlbumInvitationEntity> invitations;

  const CreateAlbumEntity({
    required this.title,
    required this.description,
    required this.coverImage,
    required this.invitations,
  });

  @override
  List<Object?> get props => [title, description, coverImage, invitations];
}
