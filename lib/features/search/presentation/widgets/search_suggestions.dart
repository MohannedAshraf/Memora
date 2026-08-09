import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memora/features/search/presentation/bloc/search_cubit.dart';
import 'package:memora/features/search/presentation/bloc/search_state.dart';
import 'package:memora/features/search/presentation/widgets/search_result_tile.dart';

class SearchSuggestions extends StatelessWidget {
  const SearchSuggestions({super.key, this.maxResults});

  final int? maxResults;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        // المستخدم لسه مبيعملش Search
        if (state is SearchInitial) {
          return const SizedBox.shrink();
        }

        // Loading
        if (state is SearchLoading) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        // Error
        if (state is SearchFailure) {
          return Padding(
            padding: EdgeInsets.all(20.w),
            child: Text(state.message, textAlign: TextAlign.center),
          );
        }

        // Results
        if (state is SearchLoaded) {
          if (state.albums.isEmpty) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: const Text("No Results", textAlign: TextAlign.center),
            );
          }

          final albums = maxResults == null
              ? state.albums
              : state.albums.take(maxResults!).toList();

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: albums.map((album) {
                return SearchResultTile(
                  title: album.title,
                  updatedAt: album.updatedAt
                      .toLocal()
                      .toString()
                      .split(" ")
                      .first,

                  // لسه Album Details مش معمول
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
