// ignore_for_file: unnecessary_underscores

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:memora/core/di/injection.dart';
import 'package:memora/features/albums/presentation/screens/add_album_members_screen.dart';
import 'package:memora/features/albums/presentation/screens/album_details_screen.dart';
import 'package:memora/features/albums/presentation/screens/album_members_screen.dart';
import 'package:memora/features/albums/presentation/screens/invited_album_screen.dart';
import 'package:memora/features/albums/presentation/screens/my_albums_screen.dart';
import 'package:memora/features/notification/presentation/bloc/notification_cubit.dart';
import 'package:memora/features/notification/presentation/screens/notifications_screen.dart';
import 'package:memora/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:memora/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:memora/features/search/presentation/screens/search_screen.dart';
import 'package:memora/features/settings/presentation/screens/settings_screen.dart';

import '../../features/auth/presentation/bloc/login_cubit.dart';
import '../../features/auth/presentation/bloc/register_cubit.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/nav_bar_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';

class AppRouter {
  AppRouter._();

  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, __) => const SplashScreen()),

      GoRoute(
        path: '/login',
        builder: (_, __) => BlocProvider(
          create: (_) => sl<LoginCubit>(),
          child: const LoginScreen(),
        ),
      ),

      GoRoute(
        path: '/register',
        builder: (_, __) => BlocProvider(
          create: (_) => sl<RegisterCubit>(),
          child: const RegisterScreen(),
        ),
      ),

     GoRoute(
        path: '/home',
        builder: (_, state) {
          final index =
              int.tryParse(state.uri.queryParameters['tab'] ?? '0') ?? 0;

          return NavBarScreen(initialIndex: index);
        },
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) {
          final query = state.uri.queryParameters['query'] ?? '';

          return SearchScreen(initialQuery: query);
        },
      ),

GoRoute(path: '/my-albums', builder: (_, __) => const MyAlbumsScreen()),

      GoRoute(
        path: '/invited-albums',
        builder: (_, __) => const InvitedAlbumsScreen(),
      ),

      GoRoute(
        path: '/album-details/:albumId',
        builder: (context, state) {
          final albumId = state.pathParameters['albumId']!;

          return AlbumDetailsScreen(albumId: albumId);
        },
      ),
     
      GoRoute(
        path: '/album-details/:albumId/members',
        builder: (context, state) {
          final albumId = state.pathParameters['albumId']!;

          final albumTitle = state.uri.queryParameters['title'] ?? 'Members';

          return AlbumMembersScreen(albumId: albumId, albumTitle: albumTitle);
        },
      ),
     GoRoute(
        path: '/edit-profile',
        builder: (context, state) {
          final profile = state.extra;

          return BlocProvider(
            create: (_) => sl<ProfileCubit>(),
            child: EditProfileScreen(profile: profile),
          );
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) {
          return const SettingsScreen();
        },
      ),
      GoRoute(
        path: '/notifications',
        builder: (_, __) => BlocProvider(
          create: (_) => sl<NotificationCubit>()..getNotifications(),
          child: const NotificationsScreen(),
        ),
      ),

      GoRoute(
        path: '/add-album-members',
        builder: (context, state) {
          final albumId = state.uri.queryParameters['albumId'] ?? '';

          final albumTitle = state.uri.queryParameters['albumTitle'] ?? '';

          return AddAlbumMembersScreen(
            albumId: albumId,
            albumTitle: albumTitle,
          );
        },
      ),

    ],
  );


  
}
