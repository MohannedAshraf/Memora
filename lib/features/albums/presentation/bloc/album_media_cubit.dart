import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecase/get_album_media_usecase.dart';
import 'album_media_state.dart';

class AlbumMediaCubit extends Cubit<AlbumMediaState> {
  final GetAlbumMediaUseCase getAlbumMediaUseCase;

  AlbumMediaCubit(this.getAlbumMediaUseCase) : super(AlbumMediaInitial());

  Future<void> getAlbumMedia(String albumId) async {
    emit(AlbumMediaLoading());

    try {
      final media = await getAlbumMediaUseCase(albumId);

      emit(AlbumMediaLoaded(media));
    } catch (e) {
      emit(AlbumMediaFailure(e.toString()));
    }
  }
}
