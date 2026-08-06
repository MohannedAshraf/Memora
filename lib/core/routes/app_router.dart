// ignore_for_file: unnecessary_underscores

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:memora/core/di/injection.dart';
import 'package:memora/features/search/presentation/screens/search_screen.dart';

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
        path: "/search",
        builder: (_, state) {
          final query = state.uri.queryParameters["query"] ?? "";

          return SearchScreen(initialQuery: query);
        },
      ),    ],
  );
}
