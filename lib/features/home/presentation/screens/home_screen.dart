import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:memora/features/search/presentation/widgets/search_suggestions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/di/injection.dart';
import '../../../search/presentation/bloc/search_cubit.dart';
import '../widgets/album_section.dart';
import '../widgets/home_header.dart';
import '../widgets/home_search_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final userName = user?.userMetadata?['full_name'] ?? "User";
    final searchController = TextEditingController();

    return BlocProvider(
      create: (_) => sl<SearchCubit>(),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Builder(
            builder: (context) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
                    child: HomeHeader(
                      userName: userName,
                      onMenuTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ),

                  SizedBox(height: 28.h),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: HomeSearchBar(
                      controller: searchController,

                      onChanged: (value) {
                        context.read<SearchCubit>().search(value);
                      },

                      onSearchPressed: () {
                        final text = searchController.text.trim();

                        context.push("/search?query=$text");
                      },
                    ),
                  ),

                  const SearchSuggestions(maxResults: 5),

                  SizedBox(height: 30.h),

                  Padding(
                    padding: EdgeInsets.only(left: 20.w),
                    child: AlbumSection(
                      title: "My Albums",
                      type: AlbumSectionType.myAlbums,
                      onSeeAll: () {},
                    ),
                  ),

                  SizedBox(height: 34.h),

                  Padding(
                    padding: EdgeInsets.only(left: 20.w),
                    child: AlbumSection(
                      title: "Invited Albums",
                      type: AlbumSectionType.invitedAlbums,
                      onSeeAll: () {},
                    ),
                  ),

                  SizedBox(height: 30.h),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
