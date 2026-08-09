import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecase/get_album_details_usecase.dart';
import 'album_details_state.dart';

class AlbumDetailsCubit extends Cubit<AlbumDetailsState> {
  final GetAlbumDetailsUseCase getAlbumDetailsUseCase;

  AlbumDetailsCubit(this.getAlbumDetailsUseCase) : super(AlbumDetailsInitial());

  Future<void> getAlbumDetails(String albumId) async {
    emit(AlbumDetailsLoading());

    try {
      final album = await getAlbumDetailsUseCase(albumId);

      emit(AlbumDetailsLoaded(album));
    } catch (e) {
      emit(AlbumDetailsFailure(e.toString()));
    }
  }
}
