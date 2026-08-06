import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memora/features/search/presentation/bloc/search_cubit.dart';
import 'package:memora/features/search/presentation/bloc/search_state.dart';
import 'package:memora/features/search/presentation/widgets/search_result_tile.dart';

class SearchSuggestions extends StatelessWidget {
  const SearchSuggestions({super.key, this.maxResults});

  final int? maxResults;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (_, state) {
        if (state is SearchInitial) {
          return const SizedBox.shrink();
        }

        if (state is SearchLoading) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is SearchFailure) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Text(state.message),
          );
        }

        if (state is SearchLoaded) {
          final albums = maxResults == null
              ? state.albums
              : state.albums.take(maxResults!).toList();

          if (albums.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(20),
              child: Text("No Results"),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: albums.map((album) {
                return SearchResultTile(
                  title: album.title,
                  updatedAt: album.updatedAt
                      .toLocal()
                      .toString()
                      .split(" ")
                      .first,
                  onTap: () {},
                );
              }).toList(),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
