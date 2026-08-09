// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memora/core/di/injection.dart';
import 'package:memora/core/theme/app-colors.dart';
import 'package:memora/features/albums/presentation/bloc/albums_cubit.dart';
import 'package:memora/features/albums/presentation/bloc/invited_album_cubit.dart';
import 'package:memora/features/create_album/presentation/bloc/create_album_cubit.dart';
import 'package:memora/features/home/presentation/widgets/app_drawer.dart';

import '../../../albums/presentation/screens/albums_screen.dart';
import '../../../create_album/presentation/screens/create_album_screen.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../invitations/presentation/screens/invitations_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';

class NavBarScreen extends StatefulWidget {
  final int initialIndex;

  const NavBarScreen({super.key, this.initialIndex = 0,
  });

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  late int currentIndex;

  DateTime? lastBackPressed;

  late final List<Widget> tabs;

  @override
  void initState() {
    super.initState();

    currentIndex = widget.initialIndex;

    tabs = [
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<AlbumsCubit>()..getMyAlbums()),
          BlocProvider(
            create: (_) => sl<InvitedAlbumsCubit>()..getInvitedAlbums(),
          ),
        ],
        child: const HomeScreen(),
      ),
      const InvitationsScreen(),
      BlocProvider(
        create: (_) => sl<CreateAlbumCubit>(),
        child: const CreateAlbumScreen(),
      ),
    const AlbumsScreen(),

      const ProfileScreen(),
    ];
  }

  void _handleBackPress() {
    final now = DateTime.now();

    if (lastBackPressed == null ||
        now.difference(lastBackPressed!) > const Duration(seconds: 2)) {
      lastBackPressed = now;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Press again to exit"),
          duration: Duration(seconds: 2),
        ),
      );

      return;
    }

    SystemNavigator.pop();
  }

  void _changeTab(int index) {
    setState(() {
      currentIndex = index;
    });

    if (index == 0) {
      final home = tabs[0];

      if (home is MultiBlocProvider) {
        Future.microtask(() {
          final homeContext = (tabs[0] as MultiBlocProvider).key;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBackPress();
      },
      child: Scaffold(
        drawer: const AppDrawer(),

        body: IndexedStack(index: currentIndex, children: tabs),

        floatingActionButton: Transform.translate(
          offset: const Offset(0, 22),
          child: FloatingActionButton(
            backgroundColor: AppColors.white,
            foregroundColor: AppColors.primary,
            onPressed: () => _changeTab(2),
            child: const Icon(Icons.add),
          ),
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        bottomNavigationBar: BottomAppBar(
          color: AppColors.primary,
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          child: SizedBox(
            height: 65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildItem(icon: Icons.home, index: 0, label: "Home"),
                _buildItem(icon: Icons.mail, index: 1, label: "Invitations"),
                const SizedBox(width: 40),
                _buildItem(
                  icon: Icons.photo_library,
                  index: 3,
                  label: "Albums",
                ),
                _buildItem(icon: Icons.person, index: 4, label: "Profile"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem({
    required IconData icon,
    required int index,
    required String label,
  }) {
    final selected = currentIndex == index;

    return InkWell(
      onTap: () => _changeTab(index),
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        width: 65,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: selected ? Colors.white : Colors.white70),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: selected ? Colors.white : Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
