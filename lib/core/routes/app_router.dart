// ignore_for_file: unnecessary_underscores

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:memora/core/di/injection.dart';
import 'package:memora/features/albums/presentation/screens/albums_screen.dart';
import 'package:memora/features/create_album/presentation/screens/create_album_screen.dart';
import 'package:memora/features/home/presentation/screens/nav_bar_screen.dart';
import 'package:memora/features/invitations/presentation/screens/invitations_screen.dart';
import 'package:memora/features/profile/presentation/screens/profile_screen.dart';

import '../../features/auth/presentation/bloc/login_cubit.dart';
import '../../features/auth/presentation/bloc/register_cubit.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';

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
        builder: (context, state) {
          final index =
              int.tryParse(state.uri.queryParameters['tab'] ?? '0') ?? 0;

          return NavBarScreen(initialIndex: index);
        },
      ),
      GoRoute(
        path: '/invitations',
        builder: (_, __) => const InvitationsScreen(),
      ),

      GoRoute(
        path: '/create-album',
        builder: (_, __) => const CreateAlbumScreen(),
      ),

      GoRoute(path: '/albums', builder: (_, __) => const AlbumsScreen()),

      GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
    ],
  );
}
