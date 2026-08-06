// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/search_albums_usecase.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchAlbumsUseCase useCase;

  SearchCubit(this.useCase) : super(SearchInitial());

  Timer? _debounce;

  void search(String query) {
    _debounce?.cancel();

    if (query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 350), () async {
      emit(SearchLoading());

      try {
        final albums = await useCase(query);
            print(albums.length);
        print(albums);
        emit(SearchLoaded(albums));
      } catch (e) {
        emit(SearchFailure(e.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
