import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/album_invitation_entity.dart';
import '../../domain/entities/create_album_entity.dart';
import '../../domain/usecases/create_album_usecase.dart';
import 'create_album_state.dart';

class CreateAlbumCubit extends Cubit<CreateAlbumState> {
  final CreateAlbumUseCase createAlbumUseCase;

  CreateAlbumCubit(this.createAlbumUseCase) : super(CreateAlbumInitial());

  Future<void> createAlbum({
    required String title,
    required String description,
    required File? coverImage,
    required List<AlbumInvitationEntity> invitations,
  }) async {
    emit(CreateAlbumLoading());

    try {
      await createAlbumUseCase(
        CreateAlbumEntity(
          title: title.trim(),
          description: description.trim(),
          coverImage: coverImage,
          invitations: invitations,
        ),
      );

      emit(CreateAlbumSuccess());
    } catch (e) {
      emit(CreateAlbumFailure(e.toString()));
    }
  }
}
