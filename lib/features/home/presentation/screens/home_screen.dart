import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:memora/features/search/presentation/widgets/search_suggestions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/di/injection.dart';
import '../../../notification/presentation/bloc/notification_cubit.dart';
import '../../../search/presentation/bloc/search_cubit.dart';
import '../widgets/album_section.dart';
import '../widgets/home_header.dart';
import '../widgets/home_search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openSearchScreen() {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      context.push("/search");
      return;
    }

    context.push("/search?query=${Uri.encodeComponent(query)}");
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    final userName = user?.userMetadata?['full_name'] ?? "User";

    return MultiBlocProvider(
      providers: [
        // Search Cubit
        BlocProvider<SearchCubit>(create: (_) => sl<SearchCubit>()),

        // Notification Cubit
        BlocProvider<NotificationCubit>(
          create: (_) => sl<NotificationCubit>()..getNotifications(),
        ),
      ],

      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ==================================================
              // HEADER
              // ==================================================
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

              // ==================================================
              // SEARCH
              // ==================================================
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),

                child: HomeSearchBar(
                  controller: _searchController,

                  onChanged: (value) {
                    context.read<SearchCubit>().search(value);
                  },

                  onSearchPressed: _openSearchScreen,
                ),
              ),

              // ==================================================
              // SEARCH SUGGESTIONS
              // ==================================================
              const SearchSuggestions(maxResults: 5),

              SizedBox(height: 30.h),

              // ==================================================
              // MY ALBUMS
              // ==================================================
              Padding(
                padding: EdgeInsets.only(left: 20.w),

                child: AlbumSection(
                  title: "My Albums",
                  type: AlbumSectionType.myAlbums,

                  onSeeAll: () {
                    context.push('/my-albums');
                  },
                ),
              ),

              SizedBox(height: 34.h),

              // ==================================================
              // INVITED ALBUMS
              // ==================================================
              Padding(
                padding: EdgeInsets.only(left: 20.w),

                child: AlbumSection(
                  title: "Invited Albums",
                  type: AlbumSectionType.invitedAlbums,

                  onSeeAll: () {
                    context.push('/invited-albums');
                  },
                ),
              ),

              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
