import 'dart:io';

import 'package:equatable/equatable.dart';

class CreateAlbumEntity extends Equatable {
  final String title;
  final String description;
  final File? coverImage;
  final List<String> invitedEmails;

  const CreateAlbumEntity({required this.title, 
  required this.description,
    required this.coverImage,
    required this.invitedEmails,
  });

  @override
  List<Object?> get props => [title, description, coverImage, invitedEmails];
}
