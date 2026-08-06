import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memora/features/home/presentation/widgets/album_card.dart';
import 'package:memora/features/home/presentation/widgets/home_search_bar.dart';
import 'package:memora/features/search/presentation/bloc/search_state.dart';

import '../../../../core/di/injection.dart';
import '../bloc/search_cubit.dart';
import '../widgets/home_search_bar_search_screen.dart';
import '../widgets/search_suggestions.dart';

class SearchScreen extends StatelessWidget {
  final String initialQuery;

  const SearchScreen({super.key, this.initialQuery = ""});
  @override
  Widget build(BuildContext context) {
   return BlocProvider(
  create: (_) => sl<SearchCubit>(),
  child: Builder(
    builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Search"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20.w),
              child: HomeSearchBarSearchScreen(
                onChanged: (value) {
                  context.read<SearchCubit>().search(value);
                },
              ),
            ),

            const Expanded(
              child: SingleChildScrollView(
                child: SearchSuggestions(),
              ),
            ),
          ],
        ),
      );
    },
  ),
);
}
}

class _SearchBody extends StatefulWidget {
  final String initialQuery;

  const _SearchBody({required this.initialQuery});

  @override
  State<_SearchBody> createState() => _SearchBodyState();
}

class _SearchBodyState extends State<_SearchBody> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(
      text: widget.initialQuery,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Search"),
      centerTitle: true,
    ),
    body: Column(
      children: [
        Padding(
          padding: EdgeInsets.all(20.w),
          child: HomeSearchBar(
            controller: controller,
            autofocus: true,
            onChanged: (value) {
              context.read<SearchCubit>().search(value);
            },
          ),
        ),

        Expanded(
          child: BlocBuilder<SearchCubit, SearchState>(
            builder: (_, state) {
              if (state is SearchLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is SearchFailure) {
                return Center(
                  child: Text(state.message),
                );
              }

              if (state is SearchLoaded) {
                if (state.albums.isEmpty) {
                  return const Center(
                    child: Text("No Albums Found"),
                  );
                }

                return GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  itemCount: state.albums.length,
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                    childAspectRatio: .66,
                  ),
                  itemBuilder: (_, index) {
                    final album = state.albums[index];

                    return AlbumCard(
                      title: album.title,
                      updatedAt: album.updatedAt
                          .toLocal()
                          .toString()
                          .split(" ")
                          .first,
                      onTap: () {},
                    );
                  },
                );
              }

              return const Center(
                child: Text("Search for albums"),
              );
            },
          ),
        ),
      ],
    ),
  );
}
}