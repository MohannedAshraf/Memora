import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memora/features/albums/domain/usecase/get_my_albums_usecase.dart';

import 'albums_state.dart';

class AlbumsCubit extends Cubit<AlbumsState> {
  final GetMyAlbumsUseCase getMyAlbumsUseCase;

  AlbumsCubit(this.getMyAlbumsUseCase) : super(AlbumsInitial());

  Future<void> getMyAlbums() async {
    emit(AlbumsLoading());

    try {
      final albums = await getMyAlbumsUseCase();

      emit(AlbumsLoaded(albums));
    } catch (e) {
      emit(AlbumsFailure(e.toString()));
    }
  }
}
