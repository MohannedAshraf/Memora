import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memora/core/widgets/special_album_card.dart';
import 'package:memora/features/home/presentation/widgets/home_search_bar.dart';

import '../../../../core/di/injection.dart';
import '../bloc/search_cubit.dart';
import '../bloc/search_state.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key, this.initialQuery = ""});

  final String initialQuery;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SearchCubit>(),
      child: _SearchBody(initialQuery: initialQuery),
    );
  }
}

class _SearchBody extends StatefulWidget {
  const _SearchBody({required this.initialQuery});

  final String initialQuery;

  @override
  State<_SearchBody> createState() => _SearchBodyState();
}

class _SearchBodyState extends State<_SearchBody> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.initialQuery);

    /// لو جايين من Home ومعانا كلمة بحث
    /// نعمل البحث تلقائيًا.
    if (widget.initialQuery.trim().isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        context.read<SearchCubit>().searchImmediately(widget.initialQuery);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// البحث يتم فقط عند الضغط على أيقونة البحث.
  void _search() {
    final query = _controller.text.trim();

    if (query.isEmpty) {
      context.read<SearchCubit>().clearSearch();
      return;
    }

    context.read<SearchCubit>().searchImmediately(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search"), centerTitle: true),

      body: Column(
        children: [
          /// Search Bar
          Padding(
            padding: EdgeInsets.all(20.w),
            child: HomeSearchBar(
              controller: _controller,

              autofocus: widget.initialQuery.trim().isEmpty,

              /// لا نبحث أثناء الكتابة.
              onChanged: (value) {
                if (value.trim().isEmpty) {
                  context.read<SearchCubit>().clearSearch();
                }
              },

              /// البحث عند الضغط على الأيقونة.
              onSearchPressed: _search,
            ),
          ),

          /// Results
          Expanded(
            child: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                /// Initial
                if (state is SearchInitial) {
                  return const Center(child: Text("Search for albums"));
                }

                /// Loading
                if (state is SearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                /// Error
                if (state is SearchFailure) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Text(state.message, textAlign: TextAlign.center),
                    ),
                  );
                }

                /// Results
                if (state is SearchLoaded) {
                  if (state.albums.isEmpty) {
                    return const Center(child: Text("No Albums Found"));
                  }

                  /// كل النتائج في ListView
                  return ListView.builder(
                    padding: EdgeInsets.only(
                      left: 16.w,
                      right: 16.w,
                      bottom: 20.h,
                    ),

                    itemCount: state.albums.length,

                    itemBuilder: (context, index) {
                      final album = state.albums[index];

                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: SpecialAlbumCard(
                          title: album.title,
                          updatedAt: album.updatedAt
                              .toLocal()
                              .toString()
                              .split(" ")
                              .first,

                          /// Album Details later
                          onTap: () {
                            // context.push(
                            //   '/album-details/${album.id}',
                            // );
                          },
                        ),
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
