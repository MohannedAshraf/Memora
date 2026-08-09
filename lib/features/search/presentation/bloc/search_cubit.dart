import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/search_albums_usecase.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchAlbumsUseCase useCase;

  SearchCubit(this.useCase) : super(SearchInitial());

  Timer? _debounce;

  /// Home Search
  /// يبحث تلقائيًا بعد توقف المستخدم عن الكتابة.
  void search(String query) {
    _debounce?.cancel();

    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      emit(SearchInitial());
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 350), ()  {
       _performSearch(trimmedQuery);
    });
  }

  /// Search Screen
  /// البحث يتم فقط عند الضغط على زر البحث.
  Future<void> searchImmediately(String query) async {
    _debounce?.cancel();

    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      emit(SearchInitial());
      return;
    }

    await _performSearch(trimmedQuery);
  }

  void clearSearch() {
    _debounce?.cancel();
    emit(SearchInitial());
  }

  Future<void> _performSearch(String query) async {
    emit(SearchLoading());

    try {
      final albums = await useCase(query);

      // مهم:
      // لا تعمل take(5) هنا.
      // الـ Home هو اللي بياخد أول 5 عند العرض.
      // Search Screen بتعرض كل النتائج.
      emit(SearchLoaded(albums));
    } catch (e) {
      emit(SearchFailure(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
