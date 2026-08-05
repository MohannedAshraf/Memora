import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memora/features/albums/domain/usecase/get_invited_album_usecase.dart';
import 'package:memora/features/albums/presentation/bloc/invited_album_state.dart';

class InvitedAlbumsCubit extends Cubit<InvitedAlbumsState> {
  final GetInvitedAlbumsUseCase useCase;

  InvitedAlbumsCubit(this.useCase) : super(InvitedAlbumsInitial());

  Future<void> getInvitedAlbums() async {
    emit(InvitedAlbumsLoading());

    try {
      final albums = await useCase();

      emit(InvitedAlbumsLoaded(albums));
    } catch (e) {
      emit(InvitedAlbumsFailure(e.toString()));
    }
  }
}
